//**********************************************************************************************************************
//
//  CustomTextField.swift
//	SwiftUI wrapper for NSTextField with custom behavior
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


typealias NSTextFieldActiveHandler = (NSCustomTextField,Bool,Bool)->Void


//----------------------------------------------------------------------------------------------------------------------


/// CustomTextField uses an underlying NSCustomTextField to achieve behavior that isn't supported by SwiftUI
/// as of 10.15 - that is why we drop down to AppKit and implement the desired behavior ourself.

struct CustomTextField<T> : NSViewRepresentable //where T:TypeCheckable
{
    @Binding var value:T
	var height:CGFloat? = nil
	var alignment:TextAlignment = .leading
	var formatter:Formatter? = nil
	var isActiveHandler:(NSTextFieldActiveHandler)? = nil

	// Create the underlying NSCustomTextField
	
    func makeNSView(context:Context) -> NSCustomTextField
    {
		var action = #selector(Coordinator.updateStringValue(with:))
		
		if value is Double
		{
			action = #selector(Coordinator.updateDoubleValue(with:))
		}
		else if value is Int
		{
			action = #selector(Coordinator.updateIntValue(with:))
		}

        let textfield = NSCustomTextField(frame:.zero)
        textfield.delegate = context.coordinator
        textfield.alignment = alignment.nstextalignment
        textfield.formatter = formatter
        textfield.fixedHeight = self.height
		textfield.target = context.coordinator
		textfield.action = action
		textfield.isActiveHandler = { self.isActiveHandler?($0,$1,$2) }
		self.isActiveHandler?(textfield,false,false)
		return textfield
    }

	// SwiftUI side has changed, so update the NSCustomTextField
	
    func updateNSView(_ textfield:NSCustomTextField, context:Context)
    {
		if let value = self.value as? String
		{
			textfield.stringValue = value
		}
		else if let value = self.value as? Double
		{
			textfield.doubleValue = value
		}
		else if let value = self.value as? Int
		{
			textfield.integerValue = value
		}
		else
		{
			textfield.stringValue = ""
		}
	}
    
    // The coordinator is responsible for notifying SwiftUI when editing occured in the NSCustomTextField
    
    class Coordinator : NSObject,NSTextFieldDelegate
    {
        var textfield:CustomTextField<T>

        init(_ textfield:CustomTextField<T>)
        {
            self.textfield = textfield
        }
		
        @objc func updateStringValue(with sender:NSTextField)
        {
            textfield.value = sender.stringValue as! T
        }
        
        @objc func updateDoubleValue(with sender:NSTextField)
        {
            textfield.value = sender.doubleValue as! T
        }
        
        @objc func updateIntValue(with sender:NSTextField)
        {
            textfield.value = sender.integerValue as! T
        }
	}
	
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
}


//----------------------------------------------------------------------------------------------------------------------


class NSCustomTextField : NSTextField
{
	var isActiveHandler:(NSTextFieldActiveHandler)? = nil
	var trackingArea:NSTrackingArea? = nil
	var isFirstResponder = false { didSet { self.notify() } }
	var isHovering = false { didSet { self.notify() } }
	var fixedHeight:CGFloat? = nil

	override init(frame:NSRect)
	{
		super.init(frame:frame)
	}
	
	required init?(coder:NSCoder)
	{
		super.init(coder:coder)
	}
	
	override var frame:NSRect
	{
		set
		{
			var f = newValue
			if let h = fixedHeight { f.size.height = h }
			super.frame = f
		}
		get
		{
			return super.frame
		}
	}
	
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
		self.isHovering = self.isEnabled
	}

	override func mouseExited(with event:NSEvent)
	{
		self.isHovering = false
	}

	override func becomeFirstResponder() -> Bool
	{
		self.isFirstResponder = true
		self.selectText(nil)
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
}


//----------------------------------------------------------------------------------------------------------------------


