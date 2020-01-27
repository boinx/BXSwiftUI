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


public typealias NSTextFieldActiveHandler = (NSCustomTextField,Bool,Bool)->Void


//----------------------------------------------------------------------------------------------------------------------


/// CustomTextField uses an underlying NSCustomTextField to achieve behavior that isn't supported by SwiftUI
/// as of 10.15 - that is why we drop down to AppKit and implement the desired behavior ourself.

public struct BXCustomTextField<T> : NSViewRepresentable //where T:TypeCheckable
{
//    @Binding public var value:T
	public var value:Binding<T>
	public var height:CGFloat? = nil
	public var alignment:TextAlignment = .leading
	public var formatter:Formatter? = nil
	public var isActiveHandler:(NSTextFieldActiveHandler)? = nil

	public init(value:Binding<T>, height:CGFloat? = nil, alignment:TextAlignment = .leading, formatter:Formatter? = nil, isActiveHandler:(NSTextFieldActiveHandler)? = nil)
	{
		self.value = value
		self.height = height
		self.alignment = alignment
		self.formatter = formatter
		self.isActiveHandler = isActiveHandler
	}
	
	// Create the underlying NSCustomTextField
	
	public func makeNSView(context:Context) -> NSCustomTextField
    {
		var action = #selector(Coordinator.updateStringValue(with:))
		
		if value.wrappedValue is URL
		{
			action = #selector(Coordinator.updateURLValue(with:))
		}
		else if value.wrappedValue is Double
		{
			action = #selector(Coordinator.updateDoubleValue(with:))
		}
		else if value.wrappedValue is Float
		{
			action = #selector(Coordinator.updateFloatValue(with:))
		}
		else if value.wrappedValue is CGFloat
		{
			action = #selector(Coordinator.updateCGFloatValue(with:))
		}
		else if value.wrappedValue is Int
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
	
	public func updateNSView(_ textfield:NSCustomTextField, context:Context)
    {
		if let value = self.value.wrappedValue as? String
		{
			textfield.stringValue = value
		}
		else if let value = self.value.wrappedValue as? URL
		{
			textfield.stringValue = value.absoluteString
		}
		else if let value = self.value.wrappedValue as? Double
		{
			textfield.doubleValue = value
		}
		else if let value = self.value.wrappedValue as? Float
		{
			textfield.floatValue = value
		}
		else if let value = self.value.wrappedValue as? CGFloat
		{
			textfield.doubleValue = Double(value)
		}
		else if let value = self.value.wrappedValue as? Int
		{
			textfield.integerValue = value
		}
		else
		{
			textfield.stringValue = ""
		}
	}
    
    // The coordinator is responsible for notifying SwiftUI when editing occured in the NSCustomTextField
    
	public class Coordinator : NSObject,NSTextFieldDelegate
    {
        var textfield:BXCustomTextField<T>

        init(_ textfield:BXCustomTextField<T>)
        {
            self.textfield = textfield
        }
		
        @objc func updateStringValue(with sender:NSTextField)
        {
            textfield.value.wrappedValue = sender.stringValue as! T
        }
 
		 @objc func updateURLValue(with sender:NSTextField)
		 {
			 textfield.value.wrappedValue = URL(string:sender.stringValue) as! T
		 }

        @objc func updateDoubleValue(with sender:NSTextField)
        {
            textfield.value.wrappedValue = sender.doubleValue as! T
        }
        
        @objc func updateFloatValue(with sender:NSTextField)
        {
            textfield.value.wrappedValue = sender.floatValue as! T
        }
        
		@objc func updateCGFloatValue(with sender:NSTextField)
		 {
			 textfield.value.wrappedValue = CGFloat(sender.doubleValue) as! T
		 }
		 
		@objc func updateIntValue(with sender:NSTextField)
        {
            textfield.value.wrappedValue = sender.integerValue as! T
        }
	}
	
	public func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
}


//----------------------------------------------------------------------------------------------------------------------


public class NSCustomTextField : NSTextField
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
	
	override public var frame:NSRect
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
	
	override public func viewDidMoveToWindow()
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
	
	override public func mouseEntered(with event:NSEvent)
	{
		self.isHovering = self.isEnabled
	}

	override public func mouseExited(with event:NSEvent)
	{
		self.isHovering = false
	}

	override public func becomeFirstResponder() -> Bool
	{
		self.isFirstResponder = true
		self.selectText(nil)
		return true
	}
	
	override public func resignFirstResponder() -> Bool
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


