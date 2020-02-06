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
	
	
	static var timecodeFormatter: BXTimeCodeFormatter =
	{
		let formatter = BXTimeCodeFormatter()
		formatter.allowsFloats = true
		formatter.minimumFractionDigits = 3
		formatter.maximumFractionDigits = 3
		formatter.hasThousandSeparators = false
		formatter.isLenient = true
		return formatter
	}()
	
}


//----------------------------------------------------------------------------------------------------------------------


public class BXTimeCodeFormatter : NumberFormatter
{
	override open func string(for objectValue:Any?) -> String?
	{
		guard let number = objectValue as? NSNumber else { return nil}
		
		let value = number.doubleValue
		let secs = Int(value)
		
		let HH = secs / 3600
		let MM = (secs / 60) % 60
		let SS = secs % 60
		let fff = Int((value-Double(secs)) * 1000.0)
		
		return String(format:timecodeFormat,HH,MM,SS,fff)
	}
	
	
	override open func getObjectValue(_ object:AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string:String, range:UnsafeMutablePointer<NSRange>?) throws
	{
		let parts = string.components(separatedBy:":")
		var multiplier = 1.0
		var value = 0.0
		
		for part in parts.reversed()
		{
			if let v = part.replacingOccurrences(of:",", with:".").doubleValue
			{
				value += v * multiplier
				multiplier *= 60.0
			}
		}
		
		object?.pointee = NSNumber(value:value)
	}
   
   
    public var timecodeFormat:String
    {
		if self.allowsFloats
		{
//			let n = self.minimumFractionDigits
			return "%d:%02d:%02d.%03d"
		}
		else
		{
			return "%d:%02d:%02d"
		}
    }
}


//----------------------------------------------------------------------------------------------------------------------

