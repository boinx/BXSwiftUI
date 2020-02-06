//**********************************************************************************************************************
//
//  Formatter+Custom.swift
//	Various custom formatters
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import Foundation


//----------------------------------------------------------------------------------------------------------------------


public extension Formatter
{
	static var secondsFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 2
		formatter.positiveFormat = "#.##s"
		formatter.negativeFormat = "-#.##s"
		formatter.hasThousandSeparators = false
		return formatter
	}()


	static var degreesFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 1
		formatter.positiveFormat = "#.#°"
		formatter.negativeFormat = "-#.#°"
		formatter.hasThousandSeparators = false
		return formatter
	}()
	
	
	static var pixelsFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = false
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 0
		formatter.positiveFormat = "#px"
		formatter.negativeFormat = "-#px"
		formatter.hasThousandSeparators = false
		return formatter
	}()
	
	
	static var pointsFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = false
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 0
		formatter.positiveFormat = "#pt"
		formatter.negativeFormat = "-#pt"
		formatter.hasThousandSeparators = false
		return formatter
	}()
	
	
	static var factorFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 1
		formatter.positiveFormat = "#x"
		formatter.negativeFormat = "-#x"
		formatter.hasThousandSeparators = false
		return formatter
	}()
	
	
	static var percentFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
//		formatter.allowsFloats = false
		formatter.numberStyle = .percent
		formatter.percentSymbol = "%"
		formatter.hasThousandSeparators = false
		formatter.isLenient = true
		return formatter
	}()
	
	
	static var doubleFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 6
		formatter.hasThousandSeparators = false
		return formatter
	}()
	
	
	static var intFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = false
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 0
		formatter.hasThousandSeparators = false
		return formatter
	}()
}


//----------------------------------------------------------------------------------------------------------------------

