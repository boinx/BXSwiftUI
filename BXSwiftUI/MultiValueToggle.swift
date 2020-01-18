import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


struct MultiValueToggle : NSViewRepresentable
{
    @Binding var values:Set<Bool>
	var label:String = ""
	
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
    
    func makeNSView(context:Context) -> NSButton
    {
        let button = NSButton(frame:.zero)
        button.setButtonType(.switch)
        button.bezelStyle = .regularSquare
        button.allowsMixedState = true
        button.title = label 
		button.target = context.coordinator
		button.action = #selector(Coordinator.updateValues(with:))
		return button
    }

    func updateNSView(_ button:NSButton, context:Context)
    {
		if values.count > 1
		{
			button.state = .mixed
			button.isEnabled = true
		}
		else if let value = values.first
		{
			button.state = value ? .on : .off
			button.isEnabled = true
		}
		else
		{
			button.state = .off
			button.isEnabled = false
		}
    }
    
    class Coordinator : NSObject,NSTextFieldDelegate
    {
        var toggle:MultiValueToggle

        init(_ toggle:MultiValueToggle)
        {
            self.toggle = toggle
        }

        @objc func updateValues(with sender:NSButton)
        {
			let value = sender.state != .off
			toggle.values = Set([value])
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------
