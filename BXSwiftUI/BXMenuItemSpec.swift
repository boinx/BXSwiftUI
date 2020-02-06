//**********************************************************************************************************************
//
//  BXMenuItemSpec.swift
//	Specifies a single menu item in a picker
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import AppKit


//----------------------------------------------------------------------------------------------------------------------


// Specifies a single menu item in a picker

public enum BXMenuItemSpec
{
	case action(icon:NSImage?, title:String, action:()->Void)
	case regular(icon:NSImage?, title:String, value:Int)
	case section(title:String)
	case divider
}


//----------------------------------------------------------------------------------------------------------------------
