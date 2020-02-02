//**********************************************************************************************************************
//
//  BXTextField.swift
//	SwiftUI wrapper for NSTextField with custom behavior
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


/// This closure is called whenever editing begin or end, or when the mouse enters or exits the textfield. This
/// information can be used to update the appearance of the textfield. The arguments are:
/// - The NSTextField
/// - A Bool indicating whether the field is currently enabled
/// - A Bool indicating whether the field is currently firstResponder (i.e. being edited)
/// - A Bool indicating whether the the mouse is currenty inside the field

public typealias BXTextFieldStatusHandler = (NSTextField,Bool,Bool,Bool)->Void


//----------------------------------------------------------------------------------------------------------------------


/// BXTextFieldWrapper uses an underlying NSTextField to achieve behavior that isn't supported by SwiftUI
/// as of 10.15 - that is why we drop down to AppKit and implement the desired behavior ourself.

public struct BXTextFieldWrapper<T> : NSViewRepresentable
{
	// Params
	
	public var value:Binding<T>
	public var height:CGFloat? = nil
	public var alignment:TextAlignment = .leading
	public var formatter:Formatter? = nil
	public var statusHandler:(BXTextFieldStatusHandler)? = nil

	// Environment
	
	@Environment(\.controlSize) var controlSize:ControlSize

	// The control size is provided by the environment. needs to be converted to NSControl datatype
	
	private var macControlSize:NSControl.ControlSize
	{
		switch controlSize
		{
			case .regular: 		return .regular
			case .small: 		return .small
			case .mini: 		return .mini
			@unknown default: 	return .regular
		}
	}

	// Only needed to make init public
	
	public init(value:Binding<T>, height:CGFloat? = nil, alignment:TextAlignment = .leading, formatter:Formatter? = nil, statusHandler:(BXTextFieldStatusHandler)? = nil)
	{
		self.value = value
		self.height = height 
		self.alignment = alignment
		self.formatter = formatter
		self.statusHandler = statusHandler
	}
	
	
	// Create the underlying NSCustomTextField
	
	public func makeNSView(context:Context) -> BXTextFieldNative
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
		
        let textfield = BXTextFieldNative(frame:.zero)
        textfield.delegate = context.coordinator
        textfield.controlSize = self.macControlSize
        textfield.alignment = alignment.nstextalignment
        textfield.formatter = formatter
        textfield.fixedHeight = self.height
		textfield.target = context.coordinator
		textfield.action = action
		textfield.isBordered = true
		textfield.drawsBackground = true
		textfield.statusHandler = self.statusHandler
		
		textfield.notify()
		
		return textfield
    }


	// SwiftUI side has changed, so update the NSCustomTextField
	
	public func updateNSView(_ textfield:BXTextFieldNative, context:Context)
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
		
		textfield.isEnabled = context.environment.isEnabled
		textfield.notify()
	}
    
    
    // The coordinator is responsible for notifying SwiftUI when editing occured in the NSCustomTextField
    
	public class Coordinator : NSObject,NSTextFieldDelegate
    {
        var textfield:BXTextFieldWrapper<T>

        init(_ textfield:BXTextFieldWrapper<T>)
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


// MARK: -

/// The BXTextFieldNative subclass provides the desired custom behavior that NSTextField doesn't provide out of the box

public class BXTextFieldNative : NSTextField
{
	var statusHandler:(BXTextFieldStatusHandler)? = nil
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
		self.statusHandler?(self, self.isEnabled, isFirstResponder, isHovering)
	}
}


//----------------------------------------------------------------------------------------------------------------------


