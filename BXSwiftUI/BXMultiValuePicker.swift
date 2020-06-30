//**********************************************************************************************************************
//
//  BXMultiValuePicker.swift
//	SwiftUI wrapper for a NSPopUpButton that supports multiple values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI
import AppKit
import Combine


//----------------------------------------------------------------------------------------------------------------------


public struct BXMultiValuePicker : NSViewRepresentable
{
	// Params
	
	private var values:Binding<Set<Int>>
	private var initialAction:(()->Void)? = nil
	private var orderedItems:[BXMenuItemSpec]

	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName
	
	// Init
	
	public init(values:Binding<Set<Int>> , initialAction:(()->Void)? = nil, orderedItems:[BXMenuItemSpec])
	{
		self.values = values
		self.initialAction = initialAction
		self.orderedItems = orderedItems
	}
	
	// Create the underlying NSPopUpButton
	
	public func makeNSView(context:Context) -> NSPopUpButton
    {
        let popup = NSPopUpButton(frame:.zero)
        popup.autoenablesItems = false
		popup.target = context.coordinator
		popup.action = #selector(Coordinator.updateValues(with:))
		
		self.rebuildMenuItems(in:popup)
		
		return popup
    }

	// Something on the SwiftUI side has changed, so update the state of the NSPopUpButton
	
	public func updateNSView(_ popup:NSPopUpButton, context:Context)
    {
		DispatchQueue.main.async
		{
			self.selectItem(for:self.values.wrappedValue, in:popup)
		}
    }
    
    /// Selects the correct menu item for the current value. If we have multiple values then the special menu item will be shown and selected.
    
    private func selectItem(for values:Set<Int>,in popup:NSPopUpButton)
    {
		let isNone = values.count == 0
		let isMultiple = values.count > 1
		
		popup.menu?.item(withTag:Values.none.rawValue)?.isHidden = !isNone
		popup.menu?.item(withTag:Values.multiple.rawValue)?.isHidden = !isMultiple
		popup.menu?.item(withTag:Values.initialDivider.rawValue)?.isHidden = !(isNone || isMultiple)

		if values.count > 1
		{
			popup.selectItem(withTag:Values.multiple.rawValue)
			popup.isEnabled = self.isEnabled
		}
		else if let value = values.first
		{
			popup.selectItem(withTag:value)
			popup.isEnabled = self.isEnabled
		}
		else
		{
			popup.selectItem(withTag:Values.none.rawValue)
			popup.isEnabled = false
		}
    }
    
    
    // Rebuilds the menu items of the popup according to the orderedItems property
    
    private func rebuildMenuItems(in popup:NSPopUpButton)
    {
		var item:NSMenuItem
		popup.menu?.removeAllItems()
		
		// Add an invisible menu item for "none" (nothing is selected)
		
		item = NSMenuItem(title:"None", action:nil, keyEquivalent:"")
		item.tag = Values.none.rawValue
		item.isEnabled = false
		item.isHidden = true
		popup.menu?.addItem(item)
		
		// Add an invisible menu item for "Multiple" (multiple different values are selected)
		
		item = NSMenuItem(title:"Multiple", action:nil, keyEquivalent:"")
		item.tag = Values.multiple.rawValue
		item.isEnabled = false
		item.isHidden = true
		popup.menu?.addItem(item)
		
		// Add an invisible initial divider
		
		item = NSMenuItem.separator()
		item.tag = Values.initialDivider.rawValue
		item.isEnabled = false
		popup.menu?.addItem(item)

		// Add menu items for transitions
		
		if let menu = popup.menu
		{
			NSMenu.addItems(self.orderedItems, to:menu)
		}
	}
    
	// The NSPopUpButton side has changed, so update the SwiftUI state
	
	public class Coordinator : NSObject
    {
        var picker:BXMultiValuePicker

        init(_ picker:BXMultiValuePicker)
        {
            self.picker = picker
        }

        @objc func updateValues(with sender:NSPopUpButton)
        {
			let tag = sender.selectedTag()
			picker.initialAction?()
			picker.values.wrappedValue = Set([tag])
			picker.undoManager?.setActionName(picker.undoName)
        }
    }
    
	public func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// Since we are dealing with multiple selection, a value can either be "none" (no selection), it can be
// "unique", or in case of multiple selected values that are different, it will be "Multiple".

fileprivate enum Values : Int
{
	case none = -2
	case multiple = -1
	case unique = 0
	case initialDivider = -3
}


//----------------------------------------------------------------------------------------------------------------------
