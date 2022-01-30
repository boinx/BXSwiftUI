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
	private var values:Binding<Set<Double>>
	private var range:ClosedRange<Double> = 0.0...60.0
	private var response:BXSliderResponse = .linear
	private var formatter:Formatter? = nil
	private var statusHandler:BXTextFieldStatusHandler? = nil
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil

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
			default: 	return 25
		}
	}
	

	// Init
	
	public init(label:String = "", values:Binding<Set<Double>>, range:ClosedRange<Double>, response:BXSliderResponse = .linear, formatter:Formatter? = nil, statusHandler:BXTextFieldStatusHandler? = nil, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.label = label
		self.values = values
		self.range = range
		self.response = response
		self.formatter = formatter
		self.statusHandler = statusHandler
		self.onBegan = onBegan
		self.onEnded = onEnded
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
					.reducedOpacityWhenDisabled()
					
				Spacer()

				BXMultiValueTextField(values:values, alignment:.trailing, formatter:formatter, statusHandler:statusHandler, onBegan:onBegan, onEnded:onEnded)
					.frame(width:60.0)
					//.reducedOpacityWhenDisabled()	// Not needed because AppKit already dimmed the control
			}
			
			BXMultiValueSlider(values:values, in:range, response:response, onBegan:onBegan, onEnded:onEnded)
				.zIndex(-1)
				.offset(x:0,y:1)
				//.reducedOpacityWhenDisabled()		// Not needed because AppKit already dimmed the control
		}
		
		// Provide fixed height to avoid layout glitches if BXDisclosureViews follow below
		
		.intrinsicContentSize(height:idealHeight)
	}
}


//----------------------------------------------------------------------------------------------------------------------


