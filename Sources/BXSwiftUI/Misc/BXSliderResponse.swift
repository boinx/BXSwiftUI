//**********************************************************************************************************************
//
//  BXSliderResponse.swift
//	Conversion functions for non-linear slider response
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import Darwin


//----------------------------------------------------------------------------------------------------------------------


/// This type contains two closures that transform value between model and view (slider) values

public struct BXSliderResponse
{
	/// Transforms a value from model to view space
	
	let modelToView:(Double)->Double

	/// Transforms a value from view to model space
	
	let viewToModel:(Double)->Double
	
	/// Indicates whether lowerBound and upperBound of range should be swapped when setting slider minValue and maxValue
	
	let reversed:Bool
}


//----------------------------------------------------------------------------------------------------------------------


extension BXSliderResponse
{
	/// Linear slide response
	
	public static let linear = BXSliderResponse(
		modelToView:{ $0 },
		viewToModel:{ $0 },
		reversed:false)
	
	/// Squared slide response (slow at first and speeding up)
	
	public static let squared = BXSliderResponse(
		modelToView:{ pow($0,0.5) },
		viewToModel:{ pow($0,2.0) },
		reversed:false)

	/// Exponential slider response
	
	public static let exponential = BXSliderResponse(
		modelToView:{ log($0) },
		viewToModel:{ exp($0) },
		reversed:false)
	
	/// Exponential slider response that is reversed
	
	public static let reversedExponential = BXSliderResponse(
		modelToView:{ -log($0) },
		viewToModel:{ exp(-$0) },
		reversed:true)
}


//----------------------------------------------------------------------------------------------------------------------
