//**********************************************************************************************************************
//
//  View+Popup.swift
//	Added macOS popup support to SwiftUI views
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Attaches a popup menu to a view hierarchy. The items are defined by an array of BXMenuItemSpec.
	/// Please note that you need to use BXMenuItemSpec.action or there will be nothing to execute!
	
    func popupMenu(value:Binding<Int>? = nil, _ itemSpecs:@autoclosure ()->[BXMenuItemSpec]) -> some View
    {
		self.overlay(BXPopupView(itemSpecs:itemSpecs(), value:value))
    }
}
  
  
//----------------------------------------------------------------------------------------------------------------------


public struct BXPopupView : NSViewRepresentable
{
	// Params
	
	private let itemSpecs:[BXMenuItemSpec]
	private let value:Binding<Int>?
	
	// State
	
	@State private var observers:[Any] = []
	
	// Init
	
    init(itemSpecs:[BXMenuItemSpec], value:Binding<Int>? = nil)
    {
         self.itemSpecs = itemSpecs
         self.value = value
    }
  
	// Create underlying NSPopUpButton
	
	public func makeNSView(context:Context) -> NSPopUpButton
	{
        let popup = _NSPopUpButton(frame:.zero)
        popup.autoenablesItems = false
		popup.isBordered = false
		popup.pullsDown = true
		popup.alphaValue = 0.01
		
		// Fill with NSMenuItems
		
		for itemSpec in itemSpecs
		{
			switch itemSpec
			{
				case .action(let icon, let name, let isEnabled, let action):
				
					let item = NSMenuItem(title:name, action:nil, keyEquivalent:"")
					item.image = icon
					item.representedObject = BXAutoEnablingAction(action:action, isEnabled:isEnabled)
					item.target = context.coordinator
					item.action = #selector(Coordinator.execute(_:))
					item.isEnabled = true
					item.isHidden = false
					item.tag = -1
					popup.menu?.addItem(item)

				case .regular(let icon, let name, let value):
					
					let item = NSMenuItem(title:name, action:nil, keyEquivalent:"")
					item.image = icon
					item.target = context.coordinator
					item.action = #selector(Coordinator.setValue(_:))
					item.isEnabled = true
					item.isHidden = false
					item.tag = value
					popup.menu?.addItem(item)
				
				case .section(let name):
				
					let item = NSMenuItem(title:name, action:nil, keyEquivalent:"")
					item.isEnabled = false
					item.tag = -1
					popup.menu?.addItem(item)
					
				case .divider:
				
					let item = NSMenuItem.separator()
					item.tag = -1
					popup.menu?.addItem(item)
			}
		}

		// WORKAROUND: There is a strange bug (as of macOS Catalina 10.15.2) where the first menu item to be add is
		// hidden when the popup is shown. In order to fix this problem, we will listen to the willPopUpNotification
		// and then walk through all item to force them to be visisble. Note that this has to be deferred to the
		// next runloop cycle because we are note allowed to change @State while building a View.
		
		DispatchQueue.main.async
		{
			self.observers += NotificationCenter.default.addAutoRemovingObserver(forName:NSPopUpButton.willPopUpNotification, object:popup, queue:OperationQueue.main)
			{
				_ in
				
				let selectedTag = self.value?.wrappedValue

				for menuItem in popup.menu?.items ?? []
				{
					// Force menu item to be visible
					
					menuItem.isHidden = false
					
					// Also update its isEnabled state
					
					if let action = menuItem.representedObject as? BXAutoEnablingAction
					{
						menuItem.isEnabled = action.isEnabled
					}
					
					// Display a checkmark for the selected item
					
					if let selectedTag = selectedTag
					{
						menuItem.state = menuItem.tag == selectedTag ? .on : .off
					}
				}
			}
		}
		
        return popup
    }
  
	public func updateNSView(_ popup:NSPopUpButton, context:Context)
    {
		if let value = self.value?.wrappedValue
		{
			popup.selectItem(withTag:value)
		}
    }
    
	// The Coordinator takes care of executing the action that is attached to the NSMenuItem
	
	public func makeCoordinator() -> Coordinator
    {
        return Coordinator(popup:self, value:value)
    }
    
	public class Coordinator : NSObject
    {
        var popup:BXPopupView
		var value:Binding<Int>?
		
        init(popup:BXPopupView, value:Binding<Int>?)
        {
			self.popup = popup
			self.value = value
        }

        @objc func execute(_ menuItem:NSMenuItem)
        {
			guard let action = menuItem.representedObject as? BXAutoEnablingAction else { return }
			action.execute()
			menuItem.state = .off
        }
 
        @objc func setValue(_ menuItem:NSMenuItem)
        {
			self.value?.wrappedValue = menuItem.tag
			menuItem.state = .on
        }
   }
}


//----------------------------------------------------------------------------------------------------------------------


// Custom subclass that forces the size of the popup to 16x16 pt, regardless of length of menu items

fileprivate class _NSPopUpButton : NSPopUpButton
{
	override open var intrinsicContentSize: NSSize
	{
		return NSMakeSize(16,16)
	}
}


//----------------------------------------------------------------------------------------------------------------------
