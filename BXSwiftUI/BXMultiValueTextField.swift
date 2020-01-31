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
	
    @Binding var values:Set<T>
	var height:CGFloat? = nil
	var alignment:TextAlignment = .leading
	var formatter:Formatter? = nil
	var isActiveHandler:(BXTextFieldActiveHandler)? = nil


	/// Creates the underlying BXNativeTextField
	
    func makeNSView(context:Context) -> BXNativeTextField
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

        let textfield = BXNativeTextField(frame:.zero)
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


	/// Something on the SwiftUI side has changed, so update the NSCustomTextField
	
    func updateNSView(_ textfield:BXNativeTextField, context:Context)
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
			textfield.isEnabled = true
		}
		else
		{
			textfield.stringValue = ""
			textfield.placeholderString = "multiple"
			textfield.isEnabled = true
		}
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
