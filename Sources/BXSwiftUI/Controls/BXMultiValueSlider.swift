//**********************************************************************************************************************
//
//  BXMultiValueNativeSlider.swift
//	SwiftUI wrapper for a NSSlider that supports multiple values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXMultiValueSlider : View
{
	// Params
	
	private var values:Binding<Set<Double>>
	private var range:ClosedRange<Double> = 0.0...1.0
	private var response:BXSliderResponse = .linear
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil
	
	// Environment
	
	@Environment(\.bxSliderStyle) private var bxSliderStyle

	// Init
	
	public init(values:Binding<Set<Double>>, in range:ClosedRange<Double> = 0.0...1.0, response:BXSliderResponse = .linear, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.values = values
		self.range = range
		self.response = response
		self.onBegan = onBegan
		self.onEnded = onEnded
	}
	
	public var body: some View
	{
		var color:Color? = nil
		var gradient:Gradient? = nil
		
		switch self.bxSliderStyle
		{
			case .native:
				color = nil
				gradient = nil
				
			case .color(let c):
				color = c
				gradient = nil
				
			case .gradient(let g):
				color = nil
				gradient = g
		}
		
		return Group
		{
			if color == nil && gradient == nil
			{
				BXMultiValueNativeSlider(
					values: self.values,
					in: self.range,
					response: self.response,
					onBegan: self.onBegan,
					onEnded: self.onEnded)
			}
			else if color != nil
			{
				BXMultiValueColorSlider(
					values: self.values,
					range: self.range,
					response: self.response,
					color: color!,
					onBegan: self.onBegan,
					onEnded: self.onEnded)
			}
			else if gradient != nil
			{
				BXMultiValueColorSlider(
					values: self.values,
					range: self.range,
					response: self.response,
					color: color!,
					onBegan: self.onBegan,
					onEnded: self.onEnded)
			}
		}
	}

}


//----------------------------------------------------------------------------------------------------------------------
