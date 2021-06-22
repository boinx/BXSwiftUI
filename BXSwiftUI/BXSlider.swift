//**********************************************************************************************************************
//
//  BXSlider.swift
//	SwiftUI wrapper for an NSSlider
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXSlider : View
{
	// Params
	
	private var value:Binding<Double>
	private var range:ClosedRange<Double> = 0.0...1.0
	private var response:BXSliderResponse = .linear
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil
	
	// Init
	
	public init(value:Binding<Double>, in range:ClosedRange<Double> = 0.0...1.0, response:BXSliderResponse = .linear, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.value = value
		self.range = range
		self.response = response
		self.onBegan = onBegan
		self.onEnded = onEnded
	}
	
	// Build Control
	
	public var body: some View
	{
		// Since BXMultiValueSlider is the more capable (general) version of this, we'll simply
		// reuse it for now, converting the single-value Binding to a multi-value Binding.
		
		BXMultiValueSlider(values: Binding<Double>.multiValue(for:value), in:range, response:response, onBegan:onBegan, onEnded:onEnded)
	}
}


//----------------------------------------------------------------------------------------------------------------------
