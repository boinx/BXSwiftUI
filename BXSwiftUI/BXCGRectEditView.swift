//**********************************************************************************************************************
//
//  BXCGRectEditView.swift
//	A view to edit a single CGRect property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXCGRectEditView : View
{
	private var label:String
	private var width:Binding<CGFloat>? = nil
	private var value:Binding<CGRect>
	private var formatter:Formatter? = nil

	private var x:Binding<CGFloat>
	private var y:Binding<CGFloat>
	private var w:Binding<CGFloat>
	private var h:Binding<CGFloat>

	@State private var isExpanded = false


	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<CGRect>, formatter:Formatter? = .pointsFormatter)
	{
		self.label = label
		self.width = width
		self.value = value
		self.formatter = formatter
		self.x = Binding.constant(0.0)			// init with dummy values
		self.y = Binding.constant(0.0)			// init with dummy values
		self.w = Binding.constant(0.0)		// init with dummy values
		self.h = Binding.constant(0.0)		// init with dummy values

		// Now that self is fully initialized and accessible, we can create the internal bindings
		// for x and y - they need access to self.value!
		
		self.x = Binding<CGFloat>(
			get: { value.wrappedValue.origin.x },
			set: { value.wrappedValue.origin.x = $0 })

		self.y = Binding<CGFloat>(
			get: { value.wrappedValue.origin.y },
			set: { value.wrappedValue.origin.y = $0 })

		self.w = Binding<CGFloat>(
			get: { value.wrappedValue.size.width },
			set: { value.wrappedValue.size.width = $0 })

		self.h = Binding<CGFloat>(
			get: { value.wrappedValue.size.height },
			set: { value.wrappedValue.size.height = $0 })
	}
	
	
	public var body: some View
	{
		BXDisclosureView(isExpanded:$isExpanded,

			header:
			{
				HStack
				{
					BXDisclosureButton(self.label, isExpanded:self.$isExpanded)
					Spacer()
				}
			},
				
			body:
			{
				VStack
				{
					HStack
					{
						Text("x")

						BXCustomTextField(value:self.x, formatter:self.formatter)
						{
							(nstextfield,_,_) in
							nstextfield.isBordered = true
							nstextfield.drawsBackground = true
						}
					}
					
					HStack
					{
						Text("y")

						BXCustomTextField(value:self.y, formatter:self.formatter)
						{
							(nstextfield,_,_) in
							nstextfield.isBordered = true
							nstextfield.drawsBackground = true
						}
					}
						
					HStack
					{
						Text("width")

						BXCustomTextField(value:self.w, formatter:self.formatter)
						{
							(nstextfield,_,_) in
							nstextfield.isBordered = true
							nstextfield.drawsBackground = true
						}
					}
					
					HStack
					{
						Text("height")

						BXCustomTextField(value:self.h, formatter:self.formatter)
						{
							(nstextfield,_,_) in
							nstextfield.isBordered = true
							nstextfield.drawsBackground = true
						}
					}
				}
			})
	}
}


//----------------------------------------------------------------------------------------------------------------------

