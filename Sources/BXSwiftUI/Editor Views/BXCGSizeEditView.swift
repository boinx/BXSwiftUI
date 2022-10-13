//**********************************************************************************************************************
//
//  BXCGSizeEditView.swift
//	A view to edit a single CGSize property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXCGSizeEditView : View
{
	// Params
	
	private var label:String
	private var value:Binding<CGSize>
	private var formatter:Formatter? = nil

	private var w:Binding<CGFloat>
	private var h:Binding<CGFloat>

	// Init
	
	public init(label:String = "", value:Binding<CGSize>, formatter:Formatter? = .pointsFormatter)
	{
		self.label = label
		self.value = value
		self.formatter = formatter
		self.w = Binding.constant(0.0)		// init with dummy values
		self.h = Binding.constant(0.0)		// init with dummy values

		// Now that self is fully initialized and accessible, we can create the internal bindings
		// for x and y - they need access to self.value!
		
		self.w = Binding<CGFloat>(
			get: { value.wrappedValue.width },
			set: { value.wrappedValue.width = $0 })

		self.h = Binding<CGFloat>(
			get: { value.wrappedValue.height },
			set: { value.wrappedValue.height = $0 })
	}

	// Build View
	
	public var body: some View
	{
		BXLabelView(label:label, alignment:.leading)
		{
			HStack(spacing:8)
			{
//				Text("w")
				
				BXTextField(value:self.w, formatter:self.formatter)

//				Text("h")
				
				BXTextField(value:self.h, formatter:self.formatter)
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
