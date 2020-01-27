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


/// A checkbox that can take three different states: on, off, and mixed. The mixed state will be used
/// if the bound values are not unique.

public struct BXMultiValueToggle : NSViewRepresentable
{
	// Params
	
    @Binding var values:Set<Bool>
	var label:String = ""
	
	
	/// Creates a checkbox style NSButton that allows for mixed state
	
    public func makeNSView(context:Context) -> NSButton
    {
        let button = NSButton(checkboxWithTitle:label, target:context.coordinator, action:#selector(Coordinator.updateValues(with:)))
        button.allowsMixedState = true
        button.title = label 
		return button
    }


	/// Something on the SwiftUI side has changed, so update the NSButton
	
    public func updateNSView(_ button:NSButton, context:Context)
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
    
    
    /// The NSButton was clicked, so update the state on the SwiftUI side
    
    public class Coordinator : NSObject
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

    public func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
}


//----------------------------------------------------------------------------------------------------------------------
