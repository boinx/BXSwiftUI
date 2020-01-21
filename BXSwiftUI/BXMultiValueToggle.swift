//**********************************************************************************************************************
//
//  BXMultiValueToggle.swift
//	SwiftUI wrapper for a checkbox that supports multiple values (via mixed state)
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


struct BXMultiValueToggle : NSViewRepresentable
{
    @Binding var values:Set<Bool>
	var label:String = ""
	
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
        var toggle:BXMultiValueToggle

        init(_ toggle:BXMultiValueToggle)
        {
            self.toggle = toggle
        }

        @objc func updateValues(with sender:NSButton)
        {
			let value = sender.state != .off
			toggle.values = Set([value])
        }
    }

    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
}


//----------------------------------------------------------------------------------------------------------------------
