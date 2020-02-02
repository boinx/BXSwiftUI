//**********************************************************************************************************************
//
//  BXMultiValueTextField.swift
//	SwiftUI wrapper for a NSTextfield that supports multiple values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


struct BXMultiValueTextField<T:Hashable> : NSViewRepresentable where T:TypeCheckable
{
	// Params
	
    @Binding public var values:Set<T>
	public var height:CGFloat? = nil
	public var alignment:TextAlignment = .leading
	public var formatter:Formatter? = nil
	public var statusHandler:(BXTextFieldStatusHandler)? = nil
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled


	// The control size is provided by the environment. Needs to be converted to NSControl datatype
	
	@Environment(\.controlSize) private var controlSize:ControlSize
	
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


	/// Creates the underlying BXNativeTextField
	
    func makeNSView(context:Context) -> BXTextFieldNative
    {
		var action = #selector(Coordinator.updateStringValues(with:))
		
		if T.isDouble
		{
			action = #selector(Coordinator.updateDoubleValues(with:))
		}
		else if T.isInt
		{
			action = #selector(Coordinator.updateIntValues(with:))
		}

        let textfield = BXTextFieldNative(frame:.zero)
        textfield.delegate = context.coordinator
        textfield.alignment = alignment.nstextalignment
        textfield.formatter = formatter
        textfield.controlSize = self.macControlSize
        textfield.fixedHeight = self.height
		textfield.target = context.coordinator
		textfield.action = action
		textfield.statusHandler = self.statusHandler
		
		textfield.notify()

		return textfield
    }


	/// Something on the SwiftUI side has changed, so update the NSCustomTextField
	
    func updateNSView(_ textfield:BXTextFieldNative, context:Context)
    {
		if values.count == 0
		{
			textfield.stringValue = ""
			textfield.placeholderString = "none"
			textfield.isEnabled = false
		}
		else if values.count == 1, let value = values.first
		{
			if let value = value as? String
			{
				textfield.stringValue = value
			}
			else if let value = value as? Double
			{
				textfield.doubleValue = value
			}
			else if let value = value as? Int
			{
				textfield.integerValue = value
			}

			textfield.placeholderString = nil
			textfield.isEnabled = self.isEnabled
		}
		else
		{
			textfield.stringValue = ""
			textfield.placeholderString = "multiple"
			textfield.isEnabled = self.isEnabled
		}

		textfield.notify()
    }
    
    
    /// Editing has finished in the NSTextField, so update the values on the SwiftUI side
    
    class Coordinator : NSObject,NSTextFieldDelegate
    {
        var textfield:BXMultiValueTextField<T>

        init(_ textfield:BXMultiValueTextField<T>)
        {
            self.textfield = textfield
        }

        @objc func updateStringValues(with sender:NSTextField)
        {
			textfield.values = Set([sender.stringValue as! T])
        }
        
        @objc func updateDoubleValues(with sender:NSTextField)
        {
            textfield.values = Set([sender.doubleValue as! T])
        }
        
        @objc func updateIntValues(with sender:NSTextField)
        {
            textfield.values = Set([sender.integerValue as! T])
        }
    }
    
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
 }


//----------------------------------------------------------------------------------------------------------------------
