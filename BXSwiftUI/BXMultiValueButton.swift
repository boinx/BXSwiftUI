//**********************************************************************************************************************
//
//  BXMultiValueButton.swift
//	SwiftUI wrapper for a checkbox that supports multiple values (via mixed state)
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


/// A button with icons that can take three different states: on, off, and mixed.
/// The mixed state will be used if the bound values are not unique.

public struct BXMultiValueButton : NSViewRepresentable
{
	// Params
	
	public var values:Binding<Set<Bool>>

    var offStateImage:NSImage?
    var onStateImage:NSImage?
    var mixedStateImage:NSImage?


	public init(values:Binding<Set<Bool>>, label:String = "", offStateImage:NSImage?, onStateImage:NSImage?, mixedStateImage:NSImage?)
	{
		self.values = values
		self.offStateImage = offStateImage
		self.onStateImage = onStateImage
		self.mixedStateImage = mixedStateImage
	}
	
	/// Creates an image based NSButton that allows for mixed state
	
	public func makeNSView(context:Context) -> NSButton
    {
        let button = NSButton(frame:.zero)
		button.title = ""
        button.setButtonType(.toggle)
        button.bezelStyle = .shadowlessSquare
        button.allowsMixedState = true
        button.imageScaling = .scaleProportionallyDown
        button.isBordered = false
		button.target = context.coordinator
		button.action = #selector(Coordinator.updateValues(with:))
		
		// Make sure that the button is only as big as the image. Please note that we assume here that
		// all images are the same size.
		
		button.image = self.offStateImage
		button.setContentHuggingPriority(.required, for:.horizontal)
		button.setContentHuggingPriority(.required, for:.vertical)
		button.setContentCompressionResistancePriority(.defaultLow, for:.horizontal)
		button.setContentCompressionResistancePriority(.defaultLow, for:.vertical)

		return button
    }

	/// Something on the SwiftUI side has changed, so update the NSButton
	
	public func updateNSView(_ button:NSButton, context:Context)
    {
		if values.wrappedValue.count > 1
		{
			button.state = .mixed
			button.image = mixedStateImage
			button.isEnabled = true
		}
		else if let value = values.wrappedValue.first
		{
			button.state = value ? .on : .off
			button.image = value ? onStateImage : offStateImage
			button.isEnabled = true
		}
		else
		{
			button.state = .off
			button.image = offStateImage
			button.isEnabled = false
		}
    }
    
    /// The NSButton was clicked, so update the state on the SwiftUI side
    
	public class Coordinator : NSObject
    {
        var button:BXMultiValueButton

        init(_ button:BXMultiValueButton)
        {
            self.button = button
        }

        @objc func updateValues(with sender:NSButton)
        {
			let value = sender.state != .off
			button.values.wrappedValue = Set([value])
        }
    }

	public func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
}


//----------------------------------------------------------------------------------------------------------------------
