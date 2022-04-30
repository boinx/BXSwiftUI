//**********************************************************************************************************************
//
//  BXTextView_macOS.swift
//	macOS implementation for BXTextView
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


#if os(macOS)

/// This closure is called whenever editing begins or ends, or when the mouse enters or exits the textview.
/// This information can be used to update the appearance of the textview. The arguments are:
/// - The NSTextView
/// - A Bool indicating whether the field is currently enabled
/// - A Bool indicating whether the field is currently firstResponder (i.e. being edited)
/// - A Bool indicating whether the the mouse is currenty inside the field

public typealias BXTextViewStatusHandler = (NSTextView,Bool,Bool,Bool)->Void

#elseif os(iOS)

/// This closure is called whenever editing begins or ends.
/// This information can be used to update the appearance of the textview. The arguments are:
/// - The UITextView
/// - A Bool indicating whether the field is currently enabled
/// - A Bool indicating whether the field is currently firstResponder (i.e. being edited)
/// - A Bool that is not used on iOS

public typealias BXTextViewStatusHandler = (UITextView,Bool,Bool,Bool)->Void

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// BXmacOSTextView uses an underlying NSTextView subclass to achieve behavior that isn't supported by SwiftUI
/// as of 10.15 - that is why we drop down to AppKit and implement the desired behavior ourself.

internal struct BXTextView_macOS : NSViewRepresentable
{
	// Params
	
    @Binding var value:NSAttributedString
	@Binding var fittingSize:CGSize
	var statusHandler:(BXTextViewStatusHandler)? = nil
	var onBegan:(()->Void)? = nil
	var onEnded:(()->Void)? = nil

	// Environment
	
	@Environment(\.isEnabled) var isEnabled:Bool
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName


	// Create the underlying NSCustomTextView
	
    func makeNSView(context:Context) -> BXNativeTextView
    {
        let textView = BXNativeTextView(frame:.zero)

		textView.isRichText = true
		textView.usesFontPanel = true
		textView.allowsUndo	= true
		
        textView.delegate = context.coordinator
        textView.statusHandler = self.statusHandler
        
        textView.textContainerInset = NSMakeSize(0.0,3.0)
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.heightTracksTextView = false
		textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autoresizingMask = [.width, .height]
		
		return textView
    }


	// SwiftUI side has changed, so update the NSTextView
	
	func updateNSView(_ textView:BXNativeTextView, context:Context)
    {
		// Save the current selection and restore it later, because the following steps
		// will replace the whole text and thus destroy the selected range.
		
		let savedSelectedRanges = textView.selectedRanges
		defer { textView.selectedRanges = savedSelectedRanges }
        
		// Replace the text with the new value
		
		let n = textView.textStorage?.length ?? 0
		let range = NSMakeRange(0,n)
		textView.textStorage?.replaceCharacters(in:range, with:self.value)
		
		// Also apply some external environment values
         
		if self.isEnabled == false
		{
			textView.setSelectedRange(NSMakeRange(0,0))
		}
		
		textView.isEditable = self.isEnabled
		textView.isSelectable = self.isEnabled

		if let lineLimit = context.environment.lineLimit
		{
            textView.textContainer?.maximumNumberOfLines = lineLimit
        }

        // Measure the size of the view (which depends on the text contents) and notify the
        // SwiftUI layout system accordingly.
        
		let size = textView.fittingSize()
		
		if !textView.isFirstResponder
		{
			DispatchQueue.main.async
			{
				self.fittingSize = size
			}
		}
		
		// Call statusHandler so that clients can update the appearance of the view accordingly
		
		textView.notify()
	}
    

    // The text was edited by the user, so notify Swift UI of the new value and changed size.

    class Coordinator : NSObject, NSTextViewDelegate
    {
        var swituiTextView:BXTextView_macOS
		var undoManager:UndoManager?
		var undoName:String

        init(_ textView:BXTextView_macOS, _ undoManager:UndoManager?, _ undoName:String)
        {
            self.swituiTextView = textView
            self.undoManager = undoManager
            self.undoName = undoName
        }
		
		func textDidBeginEditing(_ notification:Notification)
		{
			self.swituiTextView.onBegan?()
		}
		
		func textDidChange(_ notification:Notification)
		{
			guard let textView = notification.object as? BXNativeTextView else { return }
			guard let textStorage = textView.textStorage else { return }
			
			// Store the new text value in the BXCustomTextView
			
			self.swituiTextView.value = NSAttributedString(attributedString:textStorage)
			
			// Notify the SwiftUI layout system of the required size

			let size = textView.fittingSize()
			self.swituiTextView.fittingSize = size
		}
		
		func textDidEndEditing(_ notification: Notification)
		{
			self.swituiTextView.onEnded?()
			
			// Once editing end set the undoName
			
			self.undoManager?.setActionName(undoName)
		}
	}
	
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self, undoManager, undoName)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

class BXNativeTextView : NSTextView
{
	var statusHandler:(BXTextViewStatusHandler)? = nil
	var trackingArea:NSTrackingArea? = nil
	var isFirstResponder = false { didSet { self.notify() } }
	var isHovering = false { didSet { self.notify() } }

	// Create the underlying NSTextView
	
    override init(frame:NSRect, textContainer:NSTextContainer?)
    {
		super.init(frame:frame, textContainer:textContainer)
    }

	override init(frame:NSRect)
	{
		super.init(frame:frame)
	}

	required init?(coder:NSCoder)
	{
		super.init(coder:coder)
	}

	override func viewDidMoveToWindow()
	{
		super.viewDidMoveToWindow()
		
		DispatchQueue.main.async
		{
			self.prepare()
		}
	}

	// Install NSTrackingArea to track mouse enter/exit events
	
	func prepare()
	{
		let trackingArea = NSTrackingArea(rect:self.bounds, options:[.mouseEnteredAndExited,.activeAlways], owner:self, userInfo:nil)
		self.addTrackingArea(trackingArea)
		self.trackingArea = trackingArea

		self.window?.recalculateKeyViewLoop()
	}

	func cleanup()
	{
		if let trackingArea = trackingArea
		{
			self.removeTrackingArea(trackingArea)
			self.trackingArea = nil
		}
	}

	override func mouseEntered(with event:NSEvent)
	{
		self.isHovering = true //self.isEnabled
	}

	override func mouseExited(with event:NSEvent)
	{
		self.isHovering = false
	}

	// Track begin/end of editing session
	
	override func becomeFirstResponder() -> Bool
	{
		self.isFirstResponder = true
		return true
	}

	override func resignFirstResponder() -> Bool
	{
		self.isFirstResponder = false
		return true
	}

	// Notify others of changes
	
	@objc func notify()
	{
		self.statusHandler?(self, self.isEditable, isFirstResponder, isHovering)
	}
	
	// Calculate the fitting size for the text
	
	func fittingSize() -> CGSize
	{
		guard let textContainer = self.textContainer else { return .zero }
		self.layoutManager?.glyphRange(for:textContainer) // This forces a text layout pass
		let frame = self.layoutManager?.usedRect(for:textContainer) ?? NSZeroRect

		var w = frame.width + 2 * self.textContainerInset.width
		var h = frame.height + 2 * self.textContainerInset.height
		w = max(w,20.0)
		h = max(h,1.0)

		return CGSize(width:w, height:h)
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
