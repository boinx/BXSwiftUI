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
	private var labelWidth:Binding<CGFloat>? = nil
	private var value:Binding<CGSize>
	private var formatter:Formatter? = nil

	@State private var isExpanded = false
	private var width:Binding<CGFloat>
	private var height:Binding<CGFloat>

	public init(label:String, labelWidth:Binding<CGFloat>? = nil, value:Binding<CGSize>, formatter:Formatter? = .pointsFormatter)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
		self.formatter = formatter
		self.width = Binding.constant(0.0)		// init with dummy values
		self.height = Binding.constant(0.0)		// init with dummy values

		// Now that self is fully initialized and accessible, we can create the internal bindings
		// for x and y - they need access to self.value!
		
		self.width = Binding<CGFloat>(
			get: { value.wrappedValue.width },
			set: { value.wrappedValue.width = $0 })

		self.height = Binding<CGFloat>(
			get: { value.wrappedValue.height },
			set: { value.wrappedValue.height = $0 })
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
						Text("width")

						BXCustomTextField(value:self.width, formatter:self.formatter)
						{
							(nstextfield,_,_) in
							nstextfield.isBordered = true
							nstextfield.drawsBackground = true
						}
					}
					
					HStack
					{
						Text("height")

						BXCustomTextField(value:self.height, formatter:self.formatter)
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

