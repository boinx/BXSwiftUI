//**********************************************************************************************************************
//
//  BXCGPointEditView.swift
//	A view to edit a single CGPoint property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXCGPointEditView : View
{
	// Params
	
	private var label:String
	private var value:Binding<CGPoint>
	private var formatter:Formatter? = nil

	private var x:Binding<CGFloat>
	private var y:Binding<CGFloat>

	// Init
	
	public init(label:String = "", value:Binding<CGPoint>, formatter:Formatter? = .pointsFormatter)
	{
		self.label = label
		self.value = value
		self.formatter = formatter
		self.x = Binding.constant(0.0)		// init with dummy values
		self.y = Binding.constant(0.0)		// init with dummy values

		// Now that self is fully initialized and accessible, we can create the internal bindings
		// for x and y - they need access to self.value!
		
		self.x = Binding<CGFloat>(
			get: { value.wrappedValue.x },
			set: { value.wrappedValue.x = $0 })

		self.y = Binding<CGFloat>(
			get: { value.wrappedValue.y },
			set: { value.wrappedValue.y = $0 })
	}
	
	// Build View
	
	public var body: some View
	{
		BXLabelView(label:label, alignment:.leading)
		{
			HStack
			{
				Text("x")
				
				BXTextField(value:self.x, formatter:self.formatter)

				Text("y")
				
				BXTextField(value:self.y, formatter:self.formatter)
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
