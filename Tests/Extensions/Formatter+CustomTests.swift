//**********************************************************************************************************************
//
//  Formatter+CustomTests.swift
//	Unit tests for the custom formatters
//  Copyright ©2026 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import Testing
import Foundation
import AppKit
@testable import BXSwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// BXTimeCodeFormatter is attached to NSTextFields, which means NSCell calls it from inside an AppKit LAYOUT pass -
/// it asks its formatter for a string while measuring intrinsic content size. A trap in either direction therefore
/// takes the whole app down while a window is merely being laid out, which is exactly how it shipped: formatting
/// FMAudioObject's "duration unknown" sentinel crashed the Missing Files Assistant.
///
/// The forward direction is now a thin adapter over Double.timecodeString, which is tested in BXSwiftUtils. What is
/// tested here is what belongs to this class: that the adapter picks the right shape, and that the parser it still
/// owns cannot hand back a value the formatter would then choke on.

@Suite("BXTimeCodeFormatter")

struct BXTimeCodeFormatterTests
{
	/// The four shapes the class can be configured into.

	static let shapes:[(showsHours:Bool, allowsFloats:Bool)] =
	[
		(true, true),
		(true, false),
		(false, true),
		(false, false),
	]


	static func formatter(showsHours:Bool, allowsFloats:Bool) -> BXTimeCodeFormatter
	{
		let formatter = BXTimeCodeFormatter()
		formatter.showsHours = showsHours
		formatter.allowsFloats = allowsFloats
		return formatter
	}


	/// Parses a string the way an NSCell does, i.e. through the throwing ObjC entry point.

	static func value(_ formatter:BXTimeCodeFormatter, _ string:String) throws -> Double
	{
		var object:AnyObject? = nil
		try formatter.getObjectValue(&object, for:string, range:nil)
		return (object as? NSNumber)?.doubleValue ?? .nan
	}


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Formatting


	/// showsHours and allowsFloats select the shape. This mapping is the adapter's whole job, so it is the one
	/// thing that cannot be delegated to the BXSwiftUtils tests.

	@Test("The flags select the shape", arguments:
	[
		(true, true, "1:01:01.500"),
		(true, false, "1:01:01"),
		(false, true, "61:01.500"),
		(false, false, "61:01"),
	])

	func testShape(_ showsHours:Bool, _ allowsFloats:Bool, _ expected:String) throws
	{
		let formatter = Self.formatter(showsHours:showsHours, allowsFloats:allowsFloats)

		#expect(formatter.string(for:NSNumber(value:3661.5)) == expected)
	}


	/// THE regression test. Every one of these used to trap in `Int(value)`, which does not saturate.
	///
	/// greatestFiniteMagnitude is not a hypothetical: FMAudioObject.outPoint returns exactly that whenever the
	/// media file cannot be read, which is every missing audio file in every document.

	@Test("An unrepresentable value yields a placeholder rather than trapping", arguments:
	[Double.greatestFiniteMagnitude, .infinity, -.infinity, .nan, 1.0e18])

	func testUnrepresentableValue(_ value:Double) throws
	{
		for shape in Self.shapes
		{
			let formatter = Self.formatter(showsHours:shape.showsHours, allowsFloats:shape.allowsFloats)
			let string = try #require(formatter.string(for:NSNumber(value:value)))

			#expect(string.contains("--"), "\(value) in \(shape) became \(string)")
		}
	}


	/// The placeholder keeps the shape of the string it replaces, so it reads as a timecode that is not known
	/// rather than as a different timecode.

	@Test("The placeholder keeps the shape it replaces", arguments:
	[
		(true, true, "--:--:--.---"),
		(true, false, "--:--:--"),
		(false, true, "--:--.---"),
		(false, false, "--:--"),
	])

	func testPlaceholderShape(_ showsHours:Bool, _ allowsFloats:Bool, _ expected:String)
	{
		let formatter = Self.formatter(showsHours:showsHours, allowsFloats:allowsFloats)

		#expect(formatter.string(for:NSNumber(value:Double.infinity)) == expected)
	}


	/// The crash was not in this class's own call graph - it was in AppKit's. NSCell asks its formatter for a
	/// string while MEASURING the text field, so the trap fired inside a layout pass, before any FotoMagico code
	/// of its own ran. Driving a real NSTextField is what pins that stack down; formatting a value directly walks
	/// a different path and would keep passing even if the formatter were never reachable from layout again.
	///
	/// greatestFiniteMagnitude is the shipped case: it is what FMAudioObject.outPoint returns for a missing file,
	/// and this is the shared formatter instance the Audio Options inspector attaches to its In/Out fields.

	@Test("Measuring a text field showing an unknown duration does not trap", arguments:
	[Double.greatestFiniteMagnitude, .infinity, -.infinity, .nan])
	
	@MainActor func testTextFieldLayoutDoesNotTrap(_ value:Double) throws
	{
		let textfield = NSTextField(frame:.zero)
		textfield.formatter = Formatter.timecodeFormatter
		textfield.objectValue = NSNumber(value:value)

		// cellSize is the frame the crash report named, one step below intrinsicContentSize: it runs
		// cellSizeForBounds: -> _NSGetTextCellBoundingRect -> _formatObjectValue:invalid: -> the formatter.
		// intrinsicContentSize is NOT a substitute here - a bare editable field answers noIntrinsicMetric
		// without measuring anything, so the assertion would pass while touching none of this.

		let cell = try #require(textfield.cell)

		#expect(cell.cellSize.width > 0.0, "\(value)")
		#expect(textfield.stringValue.contains("--"), "\(value) displayed as \(textfield.stringValue)")
	}


	/// A non-number is not a value that cannot be represented - it is not a value at all - so it yields nil and
	/// lets NSCell fall back rather than claiming the timecode is unknown.

	@Test("A non-number yields nil")

	func testNonNumber()
	{
		#expect(Self.formatter(showsHours:true, allowsFloats:true).string(for:"hello") == nil)
		#expect(Self.formatter(showsHours:true, allowsFloats:true).string(for:nil) == nil)
	}


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Parsing


	/// The parser stays deliberately lenient, and keeps its comma substitution: this formatter sits in a text field
	/// the user types into, and "1:30,5" is how a German or French user writes ninety and a half seconds.

	@Test("Input stays leniently parsed", arguments:
	[
		("1:30", 90.0),
		("  1:30", 90.0),
		("90", 90.0),
		("1:30,5", 90.5),
		("0:01:30.500", 90.5),
	])

	func testLenientParsing(_ string:String, _ expected:Double) throws
	{
		let formatter = Self.formatter(showsHours:true, allowsFloats:true)

		#expect(try Self.value(formatter, string) == expected)
	}


	/// The placeholder must parse back to something harmless, or the guard above would merely move the crash into
	/// the next layout pass. Zero is harmless AND correct for the case that produces it: a stored outPoint of zero
	/// is documented as "the end of the audio", which is what an unknown duration means.

	@Test("A placeholder parses back to zero", arguments:
	["--:--:--.---", "--:--.---", "--:--:--", "--:--"])

	func testPlaceholderParsesToZero(_ string:String) throws
	{
		let formatter = Self.formatter(showsHours:true, allowsFloats:true)

		#expect(try Self.value(formatter, string) == 0.0)
	}


	/// NSString.doubleValue returns HUGE_VAL on overflow, so "1e400" used to store an INFINITY in the data model.
	/// JSONEncoder refuses to encode one, so that value would have made the document unsaveable.

	@Test("Overflowing input cannot store a non-finite value", arguments:
	["1e400", "-1e400", "1e400:0", "99999999999999999999999999999999e400"])

	func testOverflowingInput(_ string:String) throws
	{
		let formatter = Self.formatter(showsHours:true, allowsFloats:true)

		#expect(try Self.value(formatter, string).isFinite, "\(string)")
	}


	/// The sign belongs to the whole timecode, not to whichever component comes first.
	///
	/// "-0:00:05.500" used to come back as POSITIVE 5.5: the minus landed on a "-0" hours component, and -0.0 times
	/// 3600 is -0.0, so it vanished without trace. It has its own case here rather than being folded into the
	/// others because it is the one that failed silently - the rest were merely wrong.

	@Test("A leading sign applies to the whole timecode", arguments:
	[
		("-0:00:05.500", -5.5),
		("-1:01:01.500", -3661.5),
		("-61:01.500", -3661.5),
		("+1:30", 90.0),
	])

	func testLeadingSign(_ string:String, _ expected:Double) throws
	{
		let formatter = Self.formatter(showsHours:true, allowsFloats:true)

		#expect(try Self.value(formatter, string) == expected)
	}


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Round trip


	/// Formatting and parsing are inverse for the shapes that carry a fraction, negatives included. Without the
	/// sign handling in the parser, the negative cases here come back positive.

	@Test("A value survives a round trip", arguments:
	[0.0, 0.5, 61.25, 3661.5, -0.5, -61.25, -3661.5])

	func testRoundTrip(_ seconds:Double) throws
	{
		for shape in Self.shapes where shape.allowsFloats
		{
			let formatter = Self.formatter(showsHours:shape.showsHours, allowsFloats:shape.allowsFloats)
			let string = try #require(formatter.string(for:NSNumber(value:seconds)))

			#expect(try Self.value(formatter, string) == seconds, "\(seconds) became \(string) in \(shape)")
		}
	}


	/// The loop is closed: nothing the parser can return will make the formatter trap on the next layout pass.
	/// This is the property that actually keeps the crash fixed, rather than any single input in the lists above.

	@Test("Nothing the parser returns can make the formatter trap", arguments:
	["--:--:--.---", "--:--", "1e400", "-1e400", "inf", "nan", "", "0:00:00.000", "-1:01:01.500"])

	func testParserOutputIsAlwaysFormattable(_ string:String) throws
	{
		for shape in Self.shapes
		{
			let formatter = Self.formatter(showsHours:shape.showsHours, allowsFloats:shape.allowsFloats)
			let value = try Self.value(formatter, string)

			#expect(formatter.string(for:NSNumber(value:value)) != nil, "\(string) in \(shape)")
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
