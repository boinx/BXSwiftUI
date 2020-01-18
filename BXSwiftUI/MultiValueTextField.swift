import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


struct MultiValueTextField<T:Hashable> : NSViewRepresentable where T:TypeCheckable
{
    @Binding var values:Set<T>
	var height:CGFloat? = nil
	var alignment:TextAlignment = .leading
	var formatter:Formatter? = nil
	var isActiveHandler:(NSTextFieldActiveHandler)? = nil

    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
    
    func makeNSView(context:Context) -> NSCustomTextField
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

    func updateNSView(_ textfield:NSCustomTextField, context:Context)
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
    
    class Coordinator : NSObject,NSTextFieldDelegate
    {
        var textfield:MultiValueTextField<T>

        init(_ textfield:MultiValueTextField<T>)
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
}


//----------------------------------------------------------------------------------------------------------------------
