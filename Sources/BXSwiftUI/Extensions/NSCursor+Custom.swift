//**********************************************************************************************************************
//
//  NSCursor+Custom.swift
//	Custom cursors
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit


//----------------------------------------------------------------------------------------------------------------------


extension NSCursor
{
	public static var plus:NSCursor
	{
		guard let image = Bundle.BXSwiftUI.image(forResource:"cursor-arrow-plus") else { return .arrow }
		return NSCursor(image:image, hotSpot:NSMakePoint(3.0,4.0))
	}

	public static var minus:NSCursor
	{
		guard let image = Bundle.BXSwiftUI.image(forResource:"cursor-arrow-minus") else { return .arrow }
		return NSCursor(image:image, hotSpot:NSMakePoint(3.0,4.0))
	}
	
	public static var move:NSCursor
	{
		guard let image = Bundle.BXSwiftUI.image(forResource:"cursor-arrow-move") else { return .arrow }
		return NSCursor(image:image, hotSpot:NSMakePoint(3.0,4.0))
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
