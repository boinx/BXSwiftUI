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


public struct BXMultiValueToggle : View
{
	// Params
	
	private var values:Binding<Set<Bool>>
	private var label:String = ""
	private var initialAction:(()->Void)? = nil
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.controlSize) private var controlSize
	@Environment(\.hasMultipleValues) private var hasMultipleValues

	// Init
	
	public init(values:Binding<Set<Bool>>, label:String = "", initialAction:(()->Void)? = nil)
	{
		self.values = values
		self.label = label
		self.initialAction = initialAction
	}
	
	// Custom bindings
	
	private var valueBinding:Binding<Bool>
	{
		 Binding<Bool>(
		 
			get:
			{
				if self.values.wrappedValue.count > 1
				{
					return true
				}
				else if let value = self.values.wrappedValue.first
				{
					return value
				}
				
				return false
			},
			
			set:
			{
				self.values.wrappedValue = Set([$0])
			})
	}

	// Build the view
	
	public var body: some View
	{
		Toggle(isOn:self.valueBinding)
		{
			Text(label)
		}
		.simultaneousGesture( TapGesture().onEnded
		{
			self.initialAction?()
		})
		.hasMultipleValues(self.values.wrappedValue.count > 1)
	}
}


//----------------------------------------------------------------------------------------------------------------------


/// A checkbox that can take three different states: on, off, and mixed. The mixed state will be used
/// if the bound values are not unique.

//public struct BXMultiValueToggle : NSViewRepresentable
//{
//	// Params
//
//    @Binding public var values:Set<Bool>
//	public var label:String = ""
//
//	// Environment
//
//	@Environment(\.isEnabled) private var isEnabled
//
//
//	/// Creates a checkbox style NSButton that allows for mixed state
//
//    public func makeNSView(context:Context) -> NSButton
//    {
//        let button = NSButton(checkboxWithTitle:label, target:context.coordinator, action:#selector(Coordinator.updateValues(with:)))
//        button.allowsMixedState = true
//        button.title = label
//		return button
//    }
//
//
//	/// Something on the SwiftUI side has changed, so update the NSButton
//
//    public func updateNSView(_ button:NSButton, context:Context)
//    {
//		if values.count > 1
//		{
//			button.state = .mixed
//			button.isEnabled = self.isEnabled
//		}
//		else if let value = values.first
//		{
//			button.state = value ? .on : .off
//			button.isEnabled = self.isEnabled
//		}
//		else
//		{
//			button.state = .off
//			button.isEnabled = false
//		}
//    }
//
//
//    /// The NSButton was clicked, so update the state on the SwiftUI side
//
//    public class Coordinator : NSObject
//    {
//        var toggle:BXMultiValueToggle
//
//        init(_ toggle:BXMultiValueToggle)
//        {
//            self.toggle = toggle
//        }
//
//        @objc func updateValues(with sender:NSButton)
//        {
//			let value = sender.state != .off
//			toggle.values = Set([value])
//        }
//    }
//
//    public func makeCoordinator() -> Coordinator
//    {
//        return Coordinator(self)
//    }
//}


//----------------------------------------------------------------------------------------------------------------------
