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
	
    func popupMenu(_ itemSpecs:@autoclosure ()->[BXMenuItemSpec]) -> some View
    {
		self.overlay( BXPopupView(itemSpecs:itemSpecs()) )
    }
}
  
  
//----------------------------------------------------------------------------------------------------------------------


public struct BXPopupView : NSViewRepresentable
{
	// Params
	
	private let itemSpecs:[BXMenuItemSpec]

	@State private var observers:[Any] = []
	
	// Init
	
    init(itemSpecs:[BXMenuItemSpec])
    {
         self.itemSpecs = itemSpecs
    }
  
	// Create underlying NSPopUpButton
	
	public func makeNSView(context:Context) -> NSPopUpButton
	{
        let popup = NSPopUpButton(frame:.zero)
        popup.autoenablesItems = true
		popup.isBordered = false
		popup.pullsDown = true
		popup.alphaValue = 0.01

		// Fill with NSMenuItems
		
		for itemSpec in itemSpecs
		{
			switch itemSpec
			{
				case .action(let icon, let name, let action):
				
					let item = NSMenuItem(title:name, action:nil, keyEquivalent:"")
					item.image = icon
					item.representedObject = action
					item.target = context.coordinator
					item.action = #selector(Coordinator.execute(_:))
					item.isEnabled = true
					item.isHidden = false
					popup.menu?.addItem(item)

				case .section(let name):
				
					let item = NSMenuItem(title:name, action:nil, keyEquivalent:"")
					item.isEnabled = false
					popup.menu?.addItem(item)
					
				case .divider:
				
					let item = NSMenuItem.separator()
					popup.menu?.addItem(item)
					
				default: break
			}
		}

		// WORKAROUND: There is a strage bug (as of macOS Catalina 10.15.2) where the first menu item to be add is
		// hidden when the popup is shown. In order to fix this problem, we will listen to the willPopUpNotification
		// and then walk through all item to force them to be visisble. Note that this has to be deferred to the
		// next runloop cycle because we are note allowed to change @State while building a View.
		
		DispatchQueue.main.async
		{
			self.observers += NotificationCenter.default.addAutoRemovingObserver(forName:NSPopUpButton.willPopUpNotification, object:popup, queue:OperationQueue.main)
			{
				_ in
				
				for menuItem in popup.menu?.items ?? []
				{
					menuItem.isHidden = false
				}
			}
		}
		
        return popup
    }
  
	public func updateNSView(_ popup:NSPopUpButton, context:Context)
    {
		// NOP
    }
    
	// The Coordinator takes care of executing the action that is attached to the NSMenuItem
	
	public func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
    
	public class Coordinator : NSObject
    {
        var popup:BXPopupView

        init(_ popup:BXPopupView)
        {
			self.popup = popup
        }

        @objc func execute(_ menuItem:NSMenuItem)
        {
			guard let action = menuItem.representedObject as? ()->Void else { return }
			action()
			menuItem.state = .off
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------
