//**********************************************************************************************************************
//
//  Formatter+Custom.swift
//	Various custom formatters
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


#if os(macOS)

/// This "extension" to Image provides support for SF Symbols on macOS Catalina. when later versions of macOS
/// support this out of the box, then this code will have to tagged as unavailable on those system version to
/// avoid duplicate warnings.

public struct Image : View
{
	// Whenever new images are needed, then copy/paste the name and icon from the SF Symbols app in the
	// application folder.
	
	static let symbols =
	[
		"plus.circle" :							"􀁌",
		"plus.circle.fill" :					"􀁍",
		"minus.circle" :						"􀁎",
		"minus.circle.fill" :					"􀁏",

		"plus.square" :							"􀃜",
		"plus.square.fill" :					"􀃝",
		"minus.square" :						"􀃞",
		"minus.square.fill" :					"􀃟",

		"arrow.clockwise" : 					"􀅈",
		"arrow.clockwise.circle" : 				"􀚁",
		"arrow.clockwise.circle.fill" : 		"􀚂",
		"arrow.counterclockwise" : 				"􀅉",
		"arrow.counterclockwise.circle" :		"􀚃",
		"arrow.counterclockwise.circle.fill" : 	"􀚄",

		"square.and.pencil" :					"􀈎",
		"square.and.arrow.up" :					"􀈂",
		"square.and.arrow.up.fill" :			"􀈃",
		"square.and.arrow.down" :				"􀈄",
		"square.and.arrow.down.fill" :			"􀈅",

		"doc" :									"􀈷",
		"doc.fill" :							"􀈸",
		"arrow.up.doc" :						"􀈻",
		"arrow.up.doc.fill" :					"􀈼",
		"arrow.down.doc" :						"􀈽",
		"arrow.down.doc.fill" :					"􀈾",

		"trash" :      							"􀈑",
		"trash.fill" :							"􀈒",
		"trash.circle" :      					"􀈓",
		"trash.circle.fill" :					"􀈔",

		"star" :         						"􀋂",
		"star.fill" :    						"􀋃",

		"speaker" :      						"􀊠",
		"speaker.fill" :						"􀊡",
		"speaker.1" :      						"􀊤",
		"speaker.1.fill" :						"􀊥",
		"speaker.2" :      						"􀊦",
		"speaker.2.fill" :						"􀊧",
		"speaker.3" :      						"􀊨",
		"speaker.3.fill" :						"􀊩",
		"speaker.slash" :      					"􀊢",
		"speaker.slash.fill" :					"􀊣",
	]

	let symbol:String

	/// Provides the same API as on iOS
	
	public init(systemName:String)
	{
		self.symbol = Image.symbols[systemName] ?? "?"
	}

	// The icon is delivered inside a string that contains the pasted SF Symbol image
	
	public var body: some View
	{
		Text(symbol)
	}
}


#endif


//----------------------------------------------------------------------------------------------------------------------

