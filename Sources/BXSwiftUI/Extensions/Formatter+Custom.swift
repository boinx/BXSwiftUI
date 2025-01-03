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
		formatter.zeroSymbol = "0s"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		return formatter
	}()


	static var degreesFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 2
		formatter.positiveFormat = "#.##°"
		formatter.negativeFormat = "-#.##°"
		formatter.zeroSymbol = "0°"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
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
		formatter.zeroSymbol = "0px"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
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
		formatter.zeroSymbol = "0pt"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
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
		formatter.zeroSymbol = "0x"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		return formatter
	}()
	
	
	static var percentFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
//		formatter.allowsFloats = false
		formatter.numberStyle = .percent
		formatter.percentSymbol = "%"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		formatter.isLenient = true
		return formatter
	}()
	
	
	static var doubleFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 6
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		return formatter
	}()
	
	
	static var singleDigitFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 1
		formatter.positiveFormat = "#.#"
		formatter.negativeFormat = "-#.#"
		formatter.zeroSymbol = "0"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		return formatter
	}()


	static var doubleDigitFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 2
		formatter.positiveFormat = "#.##"
		formatter.negativeFormat = "-#.##"
		formatter.zeroSymbol = "0"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		return formatter
	}()


	static var intFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = false
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 0
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		return formatter
	}()
	
	
	static var kbitFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = false
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 0
		formatter.positiveFormat = "# kbit"
		formatter.negativeFormat = "-# kbit"
		formatter.zeroSymbol = "0 kbit"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		return formatter
	}()
	
	
	static var bitFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = false
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 0
		formatter.positiveFormat = "# bit"
		formatter.negativeFormat = "-# bit"
		formatter.zeroSymbol = "0 bit"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		return formatter
	}()
	
	
	static var HzFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = false
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 0
		formatter.positiveFormat = "# Hz"
		formatter.negativeFormat = "-# Hz"
		formatter.zeroSymbol = "0 Hz"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		return formatter
	}()
	
	
	static var timecodeFormatter: BXTimeCodeFormatter =
	{
		let formatter = BXTimeCodeFormatter()
		formatter.allowsFloats = true
		formatter.minimumFractionDigits = 3
		formatter.maximumFractionDigits = 3
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		formatter.isLenient = true
		return formatter
	}()
	
	
	static var fileSizeFormatter: ByteCountFormatter =
	{
		let formatter = ByteCountFormatter()
		formatter.allowedUnits = .useAll
		formatter.countStyle = .file
		formatter.includesUnit = true
		formatter.isAdaptive = true
		return formatter
	}()
	
	
	static var exposureTimeFormatter: BXExposureTimeFormatter =
	{
		let formatter = BXExposureTimeFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 1
		formatter.positiveFormat = "#.#"
		formatter.negativeFormat = "-#.#"
		formatter.zeroSymbol = "0"
		#if os(macOS)
		formatter.hasThousandSeparators = false
		#endif
		return formatter
	}()



	
}


//----------------------------------------------------------------------------------------------------------------------


public extension NumberFormatter
{
    func string(for value:Double) -> String?
    {
		self.string(from:NSNumber(value:value))
    }
    
    func string(for value:Int) -> String?
    {
		self.string(from:NSNumber(value:value))
    }
}


//----------------------------------------------------------------------------------------------------------------------


public class BXExposureTimeFormatter : NumberFormatter, @unchecked Sendable
{
	override open func string(for objectValue:Any?) -> String?
	{
		guard let number = objectValue as? NSNumber else { return nil }
		var value = number.doubleValue
		if value.isNaN { value = 0.0 }
	
		if value < 0.0005
		{
			return "1/4000s"
		}
		else if value < 0.001
		{
			return "1/2000s"
		}
		else if value < 0.001
		{
			return "1/2000s"
		}
		else if value < 0.005
		{
			return "1/1000s"
		}
		else if value < 0.01
		{
			return "1/500s"
		}
		else if value < 0.05
		{
			return "1/250s"
		}
		else if value < 0.1
		{
			return "1/125s"
		}
		else if value < 0.2
		{
			return "1/60s"
		}
		else if value < 0.4
		{
			return "1/30s"
		}
		else if value < 0.7
		{
			return "1/15s"
		}
		else if value < 0.14
		{
			return "1/8s"
		}
		else if value < 0.14
		{
			return "1/8s"
		}
		else if value < 0.3
		{
			return "1/4s"
		}
		else if value < 0.6
		{
			return "1/2s"
		}
		else
		{
			return self.string(for:value)
		}
	}
	
	
	override open func getObjectValue(_ object:AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string:String, range:UnsafeMutablePointer<NSRange>?) throws
	{
		let parts = string.replacingOccurrences(of:"s", with:"").components(separatedBy:":")
		let a = parts.first?.doubleValue ?? 0.0
		let b = parts.last?.doubleValue ?? 1.0
		let value = a / b
		object?.pointee = NSNumber(value:value)
	}
}


//----------------------------------------------------------------------------------------------------------------------


public class BXTimeCodeFormatter : NumberFormatter, @unchecked Sendable
{
	public var showsHours = true
	
	override open func string(for objectValue:Any?) -> String?
	{
		guard let number = objectValue as? NSNumber else { return nil }
		
		var value = number.doubleValue
		if value.isNaN { value = 0.0 }
		let secs = Int(value)
		
		let HH = secs / 3600
		let MM = (secs / 60) % 60
		let SS = secs % 60
		let fff = Int((value-Double(secs)) * 1000.0)
		
		if showsHours
		{
			if allowsFloats
			{
				return String(format:timecodeFormat,HH,MM,SS,fff)
			}
			else
			{
				return String(format:timecodeFormat,HH,MM,SS)
			}
		}
		else
		{
			if allowsFloats
			{
				return String(format:timecodeFormat,MM,SS,fff)
			}
			else
			{
				return String(format:timecodeFormat,MM,SS)
			}
		}
	}
	
	
	override open func getObjectValue(_ object:AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string:String, range:UnsafeMutablePointer<NSRange>?) throws
	{
		let parts = string.components(separatedBy:":")
		var multiplier = 1.0
		var value = 0.0
		
		for part in parts.reversed()
		{
			let str = part.replacingOccurrences(of:",", with:".") as NSString
			let v = str.doubleValue
			value += v * multiplier
			multiplier *= 60.0
		}
		
		object?.pointee = NSNumber(value:value)
	}
   
   
    public var timecodeFormat:String
    {
		if showsHours
		{
			if self.allowsFloats
			{
				return "%d:%02d:%02d.%03d"
			}
			else
			{
				return "%d:%02d:%02d"
			}
		}
		else
		{
			if self.allowsFloats
			{
				return "%02d:%02d.%03d"
			}
			else
			{
				return "%02d:%02d"
			}
		}
    }
}


//----------------------------------------------------------------------------------------------------------------------

