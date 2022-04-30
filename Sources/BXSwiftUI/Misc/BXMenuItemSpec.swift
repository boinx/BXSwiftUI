//**********************************************************************************************************************
//
//  BXMenuItemSpec.swift
//	Specifies a single menu item in a picker
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit


//----------------------------------------------------------------------------------------------------------------------


// Specifies a single menu item in a picker

public enum BXMenuItemSpec
{
	case action(icon:NSImage? = nil, title:String, isEnabled:@autoclosure ()->Bool = true, state:()->NSControl.StateValue = { .off },  action:()->Void)
	case regular(icon:NSImage? = nil, title:String, value:Int, isEnabled:@autoclosure ()->Bool = true, representedObject:Any? = nil)
	case section(title:String)
	case divider
}


//----------------------------------------------------------------------------------------------------------------------


/// Bundles a menu item action and a closure that determines whether the menu item should be enabled or disabled.

public class BXAutoEnablingAction : NSObject
{
	// The action to be executed when the menu item is selected
	
	private let action: ()->Void
	
	// This closure determines whether the menu item is enabled or disabled
	
	private let isEnabledHandler: ()->Bool
	
	// This closure determines whether the menu item is checked or not
	
	public let stateHandler: ()->NSControl.StateValue
	
	// Creates a BXAutoEnablingAction
	
	public init(action:@escaping ()->Void, isEnabled:@escaping ()->Bool = {true}, state:@escaping ()->NSControl.StateValue = { .off })
	{
		self.action = action
		self.isEnabledHandler = isEnabled
		self.stateHandler = state
	}
	
	// Executes the menu item action
	
	public func execute()
	{
		self.action()
	}
	
	@IBAction func execute(_ menuItem:NSMenuItem)
	{
		self.execute()
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
				case .action(let icon, let name, let isEnabled, let state, let action):
					
					let wrapper = BXAutoEnablingAction(action:action, isEnabled:isEnabled, state:state)
					item = NSMenuItem(title:name, action:nil, keyEquivalent:"")
					item.image = icon
					item.representedObject = wrapper
					item.target = wrapper
					item.action = #selector(BXAutoEnablingAction.execute(_:))
					item.isEnabled = isEnabled()
					item.state = state()
					item.isHidden = false
					item.tag = -1
					menu.addItem(item)
						
				// Add a regular menu item
					
				case .regular(let icon,let title, let value, let isEnabled, let representedObject):
				
					item = NSMenuItem(title:title, action:nil, keyEquivalent:"")
					item.image = icon
					item.tag = value
					item.representedObject = representedObject
					item.isEnabled = isEnabled()
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
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
