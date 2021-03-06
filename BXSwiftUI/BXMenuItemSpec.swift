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
	case regular(icon:NSImage? = nil, title:String, value:Int, representedObject:Any? = nil)
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


public extension NSMenu
{
	static func addItems(_ itemSpecs:[BXMenuItemSpec], to menu:NSMenu)
	{
		var item:NSMenuItem
		let smallFont = NSFont.systemFont(ofSize:NSFont.smallSystemFontSize)
		let smallFontAttrs = [NSAttributedString.Key.font:smallFont]
		
		for itemSpec in itemSpecs
		{
			switch itemSpec
			{
				// Add a regular menu item
					
				case .regular(let icon,let title, let value, let representedObject):
				
					item = NSMenuItem(title:title, action:nil, keyEquivalent:"")
					item.image = icon
					item.tag = value
					item.representedObject = representedObject
					item.isEnabled = true
					menu.addItem(item)
					
				// Add a section name (disabled)
				
				case .section(let title):

					item = NSMenuItem(title:title.uppercased(), action:nil, keyEquivalent:"")
					item.attributedTitle = NSAttributedString(string:title.uppercased(), attributes:smallFontAttrs)
					item.tag = -666
					item.isEnabled = false
					menu.addItem(item)
					
				// Add a separator line

				case .divider:
				
					item = NSMenuItem.separator()
					item.tag = -666
					item.isEnabled = false
					menu.addItem(item)
					
				default: break
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
