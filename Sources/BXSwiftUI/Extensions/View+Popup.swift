//**********************************************************************************************************************
//
//  View+Popup.swift
//	Added macOS popup support to SwiftUI views
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI

#if canImport(AppKit)
import AppKit
#endif


//----------------------------------------------------------------------------------------------------------------------


#if os(macOS)

public extension View
{
	/// Attaches a popup menu to a view hierarchy. The items are defined by an array of BXMenuItemSpec.
	/// Please note that you need to use BXMenuItemSpec.action or there will be nothing to execute!
	
	@ViewBuilder func popupMenu(value:Binding<Int>? = nil, _ itemSpecs:()->[BXMenuItemSpec]) -> some View
    {
		self.overlay(BXPopupView(itemSpecs:itemSpecs(), value:value))
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

// Custom subclass that forces the size of the popup to 16x16 pt, regardless of length of menu items

#if os(macOS)

fileprivate class _NSPopUpButton : NSPopUpButton
{
	override open var intrinsicContentSize:NSSize
	{
		return NSMakeSize(16,16)
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

#if os(macOS)

public struct BXPopupView : NSViewRepresentable
{
	// Params
	
	private let itemSpecs:[BXMenuItemSpec]
	private let value:Binding<Int>?
	
	// State
	
	@State private var observers:[Any] = []
	
	// Init
	
    public init(itemSpecs:[BXMenuItemSpec], value:Binding<Int>? = nil)
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
		
		let selectedTag = self.value?.wrappedValue
		
		// Fill with NSMenuItems
		
		for itemSpec in itemSpecs
		{
			switch itemSpec
			{
				case .action(let icon, let name, let isEnabled, let state, let action):
				
					let item = NSMenuItem(title:name, action:nil, keyEquivalent:"")
					item.image = icon
					item.representedObject = BXAutoEnablingAction(action:action, isEnabled:isEnabled, state:state)
					item.target = context.coordinator
					item.action = #selector(Coordinator.execute(_:))
					item.isEnabled = true
					item.state = state()
					item.isHidden = false
					item.tag = -1
					popup.menu?.addItem(item)

				case .regular(let icon, let name, let value, let isEnabled, let representedObject):
					
					let item = NSMenuItem(title:name, action:nil, keyEquivalent:"")
					item.image = icon
					item.target = context.coordinator
					item.action = #selector(Coordinator.setValue(_:))
					item.isEnabled = isEnabled()
					item.isHidden = false
					item.tag = value
					item.state = value == selectedTag ? .on : .off
					item.representedObject = representedObject
					popup.menu?.addItem(item)
				
				case .section(let name):
				
					let item = NSMenuItem(title:name, action:nil, keyEquivalent:"")
					item.attributedTitle = NSAttributedString(string:name.uppercased(), attributes:[.font:NSFont.systemFont(ofSize:11)])
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
		// and then walk through all items to force them to be visible. Note that this has to be deferred to the
		// next runloop cycle because we are not allowed to change @State while building a View.
		
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
						menuItem.state = action.stateHandler()
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
//			menuItem.state = action.stateHandler()
        }
 
        @objc func setValue(_ menuItem:NSMenuItem)
        {
			self.value?.wrappedValue = menuItem.tag
			menuItem.state = .on
        }
   }
}

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

#if os(iOS)

public extension View
{
	/// Attaches a popup menu to a view hierarchy. The items are defined by an array of BXMenuItemSpec.
	/// Please note that you need to use BXMenuItemSpec.action or there will be nothing to execute!
	
    @ViewBuilder func popupMenu(value:Binding<Int>? = nil, _ itemSpecs:()->[BXMenuItemSpec]) -> some View
    {
		if #available(iOS 14, *)
		{
			Menu( content:
			{
				let items = itemSpecs()
				
				ForEach(0 ..< items.count)
				{
					self.button(for:items[$0])
				}
			},
			label:
			{
				self
			})
		}
		else
		{
			self
		}
    }
    
    func button(for itemSpec:BXMenuItemSpec) -> some View
    {
		Group
		{
			if case .action(_,let title, let isEnabled, let state, let action) = itemSpec
			{
						Button
						{
							action()
						}
						label:
						{
							HStack
							{
								Text(state() != .off ? "✓" : " ")
								Text(title)
							}
						}
						.enabled(isEnabled())
			}
			else
			{
				EmptyView()
			}
		}
    }
}

#endif


//----------------------------------------------------------------------------------------------------------------------

