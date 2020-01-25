//**********************************************************************************************************************
//
//  BXCGPointEditView.swift
//	A view to edit a single CGPoint property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXCGPointEditView : View
{
	private var label:String
	private var labelWidth:Binding<CGFloat>? = nil
	private var value:Binding<CGPoint>
	private var formatter:Formatter? = nil

	@State private var isExpanded = false
	private var x:Binding<CGFloat>
	private var y:Binding<CGFloat>
	
	public init(label:String, labelWidth:Binding<CGFloat>? = nil, value:Binding<CGPoint>, formatter:Formatter? = .pointsFormatter)
	{
		self.label = label
		self.labelWidth = labelWidth
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
				}
			})
	}
}


//----------------------------------------------------------------------------------------------------------------------

