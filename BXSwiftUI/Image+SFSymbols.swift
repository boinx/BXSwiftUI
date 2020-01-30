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

public struct Image : View
{
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

	public init(systemName:String)
	{
		self.symbol = Image.symbols[systemName] ?? "?"
	}

	public var body: some View
	{
		Text(symbol)
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------

