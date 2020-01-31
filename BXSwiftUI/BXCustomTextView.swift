//**********************************************************************************************************************
//
//  BXCustomTextField.swift
//	SwiftUI wrapper for NSTextField with custom behavior
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


typealias NSTextViewActiveHandler = (NSTextView,Bool,Bool)->Void


//----------------------------------------------------------------------------------------------------------------------


/// CustomTextField uses an underlying NSCustomTextField to achieve behavior that isn't supported by SwiftUI
/// as of 10.15 - that is why we drop down to AppKit and implement the desired behavior ourself.

struct BXCustomTextView : NSViewRepresentable
{
    @Binding var value:NSAttributedString
	@Binding var size:CGSize
	
//	var height:CGFloat? = nil
//	var alignment:TextAlignment = .leading
//	var isActiveHandler:(NSTextViewActiveHandler)? = nil


	// Create the underlying NSCustomTextView
	
    func makeNSView(context:Context) -> NSCustomTextView
    {
        let textView = NSCustomTextView(frame:.zero)
        textView.delegate = context.coordinator
        textView.textContainerInset = NSMakeSize(0.0,4.0)

		textView.window?.makeFirstResponder(textView)
		return textView
    }


	// SwiftUI side has changed, so update the NSTextView
	
    func updateNSView(_ textView:NSCustomTextView, context:Context)
    {
		let n = textView.textStorage?.length ?? 0
		let range = NSMakeRange(0,n)
		
		textView.textStorage?.replaceCharacters(in:range, with:self.value)
		
		DispatchQueue.main.async
		{
			self.size = textView.calulateSize()
		}
	}
    

    // The coordinator is responsible for notifying SwiftUI when editing occured in the NSCustomTextField

    class Coordinator : NSObject, NSTextViewDelegate
    {
        var swituiTextView:BXCustomTextView

        init(_ textView:BXCustomTextView)
        {
            self.swituiTextView = textView
        }
		
		func textDidChange(_ notification:Notification)
		{
			guard let textView = notification.object as? NSCustomTextView else { return }
			guard let textStorage = textView.textStorage else { return }
			
			// Store the new text value in the BXCustomTextView
			
			self.swituiTextView.value = NSAttributedString(attributedString:textStorage)
			
			// Notify the SwiftUI layout system of the required size
			
			self.swituiTextView.size = textView.calulateSize()
		}
	}
	
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

class NSCustomTextView : NSTextView
{
	var trackingArea:NSTrackingArea? = nil
	var isFirstResponder = false { didSet { self.notify() } }
	var isHovering = false { didSet { self.notify() } }
	var isActiveHandler:(NSTextViewActiveHandler)? = nil
//	var fixedHeight:CGFloat? = nil

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

//	override var frame:NSRect
//	{
//		set
//		{
//			var f = newValue
//			if let h = fixedHeight { f.size.height = h }
//			super.frame = f
//		}
//		get
//		{
//			return super.frame
//		}
//	}

	override func viewDidMoveToWindow()
	{
		super.viewDidMoveToWindow()
		
		DispatchQueue.main.async
		{
			self.prepare()
		}
	}

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

	override func becomeFirstResponder() -> Bool
	{
		self.isFirstResponder = true
//		self.selectText(nil)
		return true
	}

	override func resignFirstResponder() -> Bool
	{
		self.isFirstResponder = false

//		if self.nextKeyView == nil, let window = self.window
//		{
//			DispatchQueue.main.async
//			{
//				let firstResponder = window.initialFirstResponder
//				window.makeFirstResponder(firstResponder	)
//			}
//		}

		return true
	}

	@objc func notify()
	{
		self.isActiveHandler?(self,isFirstResponder,isHovering)
	}
	
	func calulateSize() -> CGSize
	{
		guard let textContainer = self.textContainer else { return .zero }
		
		self.layoutManager?.glyphRange(for:textContainer) // This forces a text layout pass
		let frame = self.layoutManager?.usedRect(for:textContainer) ?? NSZeroRect
		
		return CGSize(width:frame.width, height:frame.height+8.0)
	}
}


//----------------------------------------------------------------------------------------------------------------------


