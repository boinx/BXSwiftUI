//**********************************************************************************************************************
//
//  BXTextView_macOS.swift
//	macOS implementation for BXTextView
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


#if os(macOS)

/// This handler is called repeately as text editing begin or ends, and when the mouse enters or exits the view.
/// The arguments are the NSTextView, a Bool indicating whether it is firstResponder (currently editing), and
/// a Bool indicating whether the mouse is currently inside the view. The appearance can be modified as desired.

public typealias BXTextViewActiveHandler = (NSTextView,Bool,Bool)->Void

#elseif os(iOS)

/// This handler is called repeately as text editing begin or ends. The argument are the UITextView and a Bool
/// indicating whether the text is currently being edited. The appearance can be modified as desired.

public typealias BXTextViewActiveHandler = (UITextView,Bool)->Void


#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// BXmacOSTextView uses an underlying NSTextView subclass to achieve behavior that isn't supported by SwiftUI
/// as of 10.15 - that is why we drop down to AppKit and implement the desired behavior ourself.

internal struct BXTextView_macOS : NSViewRepresentable
{
    @Binding var value:NSAttributedString
	@Binding var fittingSize:CGSize
	var isActiveHandler:(BXTextViewActiveHandler)? = nil


	// Create the underlying NSCustomTextView
	
    func makeNSView(context:Context) -> BXNativeTextView
    {
        let textView = BXNativeTextView(frame:.zero)

		textView.isRichText = true
		textView.usesFontPanel = true
		textView.allowsUndo	= true
		
        textView.delegate = context.coordinator
        textView.isActiveHandler = self.isActiveHandler
        
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
		
		if let lineLimit = context.environment.lineLimit
		{
            textView.textContainer?.maximumNumberOfLines = lineLimit
        }
         
        // The first time we get here, we need to measure the size of the view (which depends
        // on the text) and notify the SwiftUI layout system accordingly.
        
        if context.coordinator.updateCount == 0
        {
			let size = textView.fittingSize()
			
			DispatchQueue.main.async
			{
				self.fittingSize = size
			}
		}
		
		context.coordinator.updateCount += 1
	}
    

    // The text was edited by the user, so notify Swift UI of the new value and changed size.

    class Coordinator : NSObject, NSTextViewDelegate
    {
        var swituiTextView:BXTextView_macOS
		var updateCount = 0

        init(_ textView:BXTextView_macOS)
        {
            self.swituiTextView = textView
        }
		
		func textDidChange(_ notification:Notification)
		{
			guard let textView = notification.object as? BXNativeTextView else { return }
			guard let textStorage = textView.textStorage else { return }
			
			// Store the new text value in the BXCustomTextView
			
			self.swituiTextView.value = NSAttributedString(attributedString:textStorage)
			
			// Notify the SwiftUI layout system of the required size

			self.swituiTextView.fittingSize = textView.fittingSize()
		}
	}
	
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

class BXNativeTextView : NSTextView
{
	var isActiveHandler:(BXTextViewActiveHandler)? = nil
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
		self.isActiveHandler?(self,isFirstResponder,isHovering)
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
		h = max(h,20.0)

		return CGSize(width:w, height:h)
	}
}


//----------------------------------------------------------------------------------------------------------------------
