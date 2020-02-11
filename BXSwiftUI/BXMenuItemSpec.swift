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
	case action(icon:NSImage? = nil, title:String, isEnabled:@autoclosure ()->Bool = true, action:()->Void)
	case regular(icon:NSImage? = nil, title:String, value:Int)
	case section(title:String)
	case divider
}


//----------------------------------------------------------------------------------------------------------------------


/// Bundles a menu item action and a closure that determines whether the menu item should be enabled or disabled.

public struct BXAutoEnablingAction
{
	// The action to be executed when the menu item is selected
	
	private let action: ()->Void
	
	// This closure determines whether the menu item is enabled or disabled
	
	private let isEnabledHandler: ()->Bool
	
	// Creates a BXAutoEnablingAction
	
	public init(action:@escaping ()->Void, isEnabled:@escaping ()->Bool = {true})
	{
		self.action = action
		self.isEnabledHandler = isEnabled
	}
	
	// Executes the menu item action
	
	public func execute()
	{
		self.action()
	}
	
	// Determine the enabled state of the menu item
	
	public var isEnabled : Bool
	{
		return self.isEnabledHandler()
	}
}


//----------------------------------------------------------------------------------------------------------------------
