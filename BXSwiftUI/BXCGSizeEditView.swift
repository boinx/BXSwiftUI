//**********************************************************************************************************************
//
//  BXCGSizeEditView.swift
//	A view to edit a single CGSize property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXCGSizeEditView : View
{
	private var label:String
	private var width:Binding<CGFloat>? = nil
	private var value:Binding<CGSize>
	private var formatter:Formatter? = nil

	private var w:Binding<CGFloat>
	private var h:Binding<CGFloat>
	@State private var isExpanded = false


	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<CGSize>, formatter:Formatter? = .pointsFormatter)
	{
		self.label = label
		self.width = width
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


	public var body: some View
	{
		BXLabelView(label:label, width:width)
		{
			HStack
			{
				Text("width")
				
				BXTextField(value:self.w, height:21, formatter:self.formatter)

				Text("height")
				
				BXTextField(value:self.h, height:21, formatter:self.formatter)
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

