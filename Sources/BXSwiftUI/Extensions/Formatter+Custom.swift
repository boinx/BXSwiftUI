//**********************************************************************************************************************
//
//  Formatter+Custom.swift
//	Various custom formatters
//  Copyright ©2020-2026 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
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
	
	/// Converts a time in seconds to a timecode string.
	
	override open func string(for objectValue:Any?) -> String?
	{
		guard let number = objectValue as? NSNumber else { return nil }
		
		// The arithmetic lives in BXSwiftUtils, and deliberately so: this used to be a second copy of it, and the
		// copy kept a trap the original had already fixed. `Int(_:)` does not saturate, so any value the Int
		// conversion cannot represent took the whole app down - and FMAudioObject.outPoint hands this formatter
		// Double.greatestFiniteMagnitude whenever the media file cannot be read. That is not a rare path: it
		// happens to every missing audio file, and it crashed inside an AppKit LAYOUT pass, because NSCell asks its
		// formatter for a string while measuring the text field's intrinsic content size. Nothing here may trap.

		return number.doubleValue.timecodeString(showsHours:showsHours, showsFraction:allowsFloats)
	}
	
	
	/// Converts a timecode string back to a time in seconds.
	
	override open func getObjectValue(_ object:AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string:String, range:UnsafeMutablePointer<NSRange>?) throws
	{
		// Kept separate from `String.timecodeValue()`, which is stricter than a live text field can afford to be: it
		// rejects "90." and, decisively, it has no comma-to-point substitution, so it would stop German and French
		// users typing "1:30,5" into a field that also sets `isLenient`.
		
		// This never fails. Returning an error instead would make AppKit beep and refuse to end editing, trapping the
		// user in a field that may be showing nothing but the "--:--:--.---" placeholder.

		// Take the sign off the front ONCE, before splitting. Leaving it attached makes it a property of whichever
		// component happens to come first, which is both wrong and invisible: "-0:00:05.500" came back as POSITIVE
		// 5.5, because the minus landed on a "-0" hours component and -0.0 times 3600 is -0.0. Now that the
		// formatter writes a negative timecode with a leading minus, that is a live round trip, not a latent one.
		
		var body = string.trimmingCharacters(in:.whitespaces)
		var sign = 1.0
		
		if body.hasPrefix("-")
		{
			sign = -1.0
			body.removeFirst()
		}
		else if body.hasPrefix("+")
		{
			body.removeFirst()
		}
		
		let parts = body.components(separatedBy:":")
		var multiplier = 1.0
		var value = 0.0
		
		for part in parts.reversed()
		{
			let str = part.replacingOccurrences(of:",", with:".") as NSString
			let v = str.doubleValue
			value += v * multiplier
			multiplier *= 60.0
		}
		
		value *= sign
		
		// NSString.doubleValue returns HUGE_VAL on overflow, so typing "1e400" yields an infinity. Handing that to
		// the data model would be worse than the crash it came from: FMAudioObject clips it away, but other clients
		// do not, and JSONEncoder refuses to encode a non-finite Double - an unsaveable document.
		
		object?.pointee = NSNumber(value:value.isFinite ? value : 0.0)
	}
   
   
    /// The printf format for the current shape.
    ///
    /// No longer used by this class - `string(for:)` names the fields it wants instead of assembling them - but
    /// kept because BXSwiftUI ships to other Boinx apps that are not in this workspace.
    
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

