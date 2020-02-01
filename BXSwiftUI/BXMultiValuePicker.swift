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


//----------------------------------------------------------------------------------------------------------------------


public struct BXMultiValuePicker : NSViewRepresentable
{
	// Binding to a set of zero or more Int values
	
	@Binding public var values:Set<Int>
	
	// An ordered list of info for creating the popup menu items
	
	public var orderedItems:[BXMenuItemSpec] = []

	// Environment
	
	@Environment(\.isEnabled) private var isEnabled


	// Create an NSPopUpButton
	
	public func makeNSView(context:Context) -> NSPopUpButton
    {
		var item:NSMenuItem
		let smallFont = NSFont.systemFont(ofSize:NSFont.smallSystemFontSize)
		let smallFontAttrs = [NSAttributedString.Key.font:smallFont]

		// Create the popup menu
		
        let popup = NSPopUpButton(frame:.zero)
        popup.autoenablesItems = false
		popup.target = context.coordinator
		popup.action = #selector(Coordinator.updateValues(with:))
		
		// Add an invisible menu item for "none" (nothing is selected)
		
        item = NSMenuItem(title:"none", action:nil, keyEquivalent:"")
		item.tag = Values.none.rawValue
		item.isEnabled = false
		item.isHidden = true
		popup.menu?.addItem(item)
        
		// Add an invisible menu item for "multiple" (multiple different values are selected)
		
		item = NSMenuItem(title:"multiple", action:nil, keyEquivalent:"")
		item.tag = Values.multiple.rawValue
		item.isEnabled = false
		item.isHidden = true
		popup.menu?.addItem(item)
        
        for itemSpec in self.orderedItems
        {
			switch itemSpec
			{
				// Add a regular menu item
					
				case .regular(let icon,let title,let value):
				
					item = NSMenuItem(title:title, action:nil, keyEquivalent:"")
					item.image = icon
					item.tag = value
					item.isEnabled = true

				// Add a section name (disabled)
				
				case .section(let title):

					item = NSMenuItem(title:title.uppercased(), action:nil, keyEquivalent:"")
					item.attributedTitle = NSAttributedString(string:title.uppercased(),attributes:smallFontAttrs)
					item.tag = -666
					item.isEnabled = false

				// Add a separator line

				case .divider:
				
					item = NSMenuItem.separator()
					item.tag = -666
					item.isEnabled = false
			}
						
			popup.menu?.addItem(item)
        }
        
		return popup
    }

	// Something on the SwiftUI side has changed, so update the state of the NSPopUpButton
	
	public func updateNSView(_ popup:NSPopUpButton, context:Context)
    {
		popup.menu?.item(withTag:Values.none.rawValue)?.isHidden = values.count > 0
		popup.menu?.item(withTag:Values.multiple.rawValue)?.isHidden = values.count < 2

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
			picker.values = Set([tag])
        }
    }
    
	public func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// Since we are dealing with multiple selection, a value can either be "none" (no selection), it can be
// "unique", or in case of multiple selected values that are different, it will be "multiple".

fileprivate enum Values : Int
{
	case none = -2
	case multiple = -1
	case unique = 0
}


//----------------------------------------------------------------------------------------------------------------------


struct StrokedPopupStyle : ViewModifier
{
    func body(content:Content) -> some View
    {
        content
			.background(
				RoundedRectangle(cornerRadius:4.0)
					.inset(by:1.0)
					.fill(Color.black)
			)
			.overlay(
				RoundedRectangle(cornerRadius:4.0)
					.inset(by:1.0)
					.stroke(Color.gray, lineWidth:0.5)
			)
    }
}


//----------------------------------------------------------------------------------------------------------------------
