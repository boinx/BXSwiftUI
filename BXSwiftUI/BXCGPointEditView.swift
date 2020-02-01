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
	private var width:Binding<CGFloat>? = nil
	private var value:Binding<CGPoint>
	private var formatter:Formatter? = nil

	private var x:Binding<CGFloat>
	private var y:Binding<CGFloat>
	@State private var isExpanded = false


	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<CGPoint>, formatter:Formatter? = .pointsFormatter)
	{
		self.label = label
		self.width = width
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
		BXLabelView(label:label, width:width)
		{
			HStack
			{
				Text("x")
				BXTextField(value:self.x, height:21, formatter:self.formatter)
					.alignmentGuide(.firstTextBaseline, computeValue:{ _ in 15.0 })

				Text("y")
				BXTextField(value:self.y, height:21, formatter:self.formatter)
					.alignmentGuide(.firstTextBaseline, computeValue:{ _ in 15.0 })
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

