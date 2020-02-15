//**********************************************************************************************************************
//
//  BXMultiValueDoubleInspectorView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Inspector view for multiple values of Double

public struct BXMultiValueDoubleInspectorView: View
{
	// Params
	
	private var label:String = ""
	private var width:Binding<CGFloat>? = nil
	private var values:Binding<Set<Double>>
	private var range:ClosedRange<Double> = 0.0...60.0
	private var response:BXSliderResponse = .linear
	private var formatter:Formatter? = nil
	private var statusHandler:BXTextFieldStatusHandler? = nil

	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.controlSize) private var controlSize

	private var idealHeight:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 25
			case .small: 		return 25
			case .mini: 		return 25
			@unknown default: 	return 25
		}
	}
	

	// Init
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, values:Binding<Set<Double>>, range:ClosedRange<Double>, response:BXSliderResponse = .linear, formatter:Formatter? = nil, statusHandler:BXTextFieldStatusHandler? = nil)
	{
		self.label = label
		self.width = width
		self.values = values
		self.range = range
		self.response = response
		self.formatter = formatter
		self.statusHandler = statusHandler
	}
	
	private var value:Double
	{
		return values.wrappedValue.first ?? 0.0
	}
	
	// Build view
	
    public var body: some View
    {
		return VStack(alignment:.leading, spacing:-2.0)
		{
			HStack
			{
				Text(label)
					.opacity(isEnabled ? 1.0 : 0.33)

				Spacer()

				BXMultiValueTextField(values:values, alignment:.trailing, formatter:formatter, statusHandler:statusHandler)
					.frame(width:60.0)
			}
			
			BXMultiValueSlider(values:values, in:range, response:response)
				.zIndex(-1)
				.offset(x:0,y:1)
		}

		// Provide fixed height to avoid layout glitches if BXDisclosureViews follow below
		
//		.border(Color.green)
		.intrinsicContentSize(height:idealHeight)
	}
}


//----------------------------------------------------------------------------------------------------------------------


