//**********************************************************************************************************************
//
//  BXMultiValuePicker.swift
//	SwiftUI wrapper for a NSPopUpButton that supports multiple values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import BXUIKit
import SwiftUI
import AppKit
import Combine


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


// MARK:-

public struct BXMultiValuePicker : NSViewRepresentable
{
	// Params
	
	private var values:Binding<Set<Int>>
	private var initialAction:(()->Void)? = nil
	private var orderedItems:[BXMenuItemSpec]

	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxColorTheme) private var bxColorTheme
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
        popup.cell = BXPopUpButtonCell(textCell:"", pullsDown:false)
        popup.isBordered = false
        popup.autoenablesItems = false
		popup.target = context.coordinator
		popup.action = #selector(Coordinator.updateValues(with:))
		
		self.rebuildMenuItems(in:popup)
		self.setColors(of:popup)
		
		return popup
    }

	// Something on the SwiftUI side has changed, so update the state of the NSPopUpButton
	
	public func updateNSView(_ popup:NSPopUpButton, context:Context)
    {
		popup.isBordered = false //colorScheme == .light

		self.setColors(of:popup)

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
    
	private func setColors(of popup:NSPopUpButton)
    {
		guard let cell = popup.cell as? BXPopUpButtonCell else { return }
		cell.fillColor = NSColor(bxColorTheme.fillColor(for:colorScheme, enhanceBy: colorScheme == .dark ? 0.5 : 1.0))
		cell.strokeColor = NSColor(bxColorTheme.strokeColor(for:colorScheme, enhanceBy: colorScheme == .dark ? 1.0 : 0.6))
		cell.hiliteColor = NSColor(bxColorTheme.hiliteColor())
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


// MARK: -

class BXPopUpButtonCell : NSPopUpButtonCell
{
	var fillColor = NSColor(calibratedWhite:1.0, alpha:0.05)
	var strokeColor = NSColor(calibratedWhite:1.0, alpha:0.65)
	var hiliteColor = NSColor.controlAccentColor
	
	var isDarkScheme:Bool
	{
		let name = self.controlView?.effectiveAppearance.name ?? NSAppearance.Name.darkAqua
		return name == NSAppearance.Name.darkAqua
	}

    override open func drawBorderAndBackground(withFrame cellFrame:NSRect, in controlView:NSView)
    {
		// For dark mode do custom drawing, because system drawing looks UGLY!
		
//		if isDarkScheme
//		{
			NSGraphicsContext.saveGraphicsState()
			defer { NSGraphicsContext.restoreGraphicsState() }
			
			var frame = cellFrame //.insetBy(dx:0.5, dy:0.5)
			
			if self.controlSize == .small
			{
				let dy = 0.5 * (frame.height - 18.0)
				frame = frame.insetBy(dx:0.0, dy:dy)
			}
			
			var arrowBox = frame
			arrowBox.size.width = 16
			arrowBox.origin.x = frame.maxX - 16
			
			let path = NSBezierPath(roundedRect:frame, cornerRadius:4)
			path.lineWidth = 1.0
			path.setClip()
			
			// Background fill
			
			self.fillColor.set()
			path.fill()
			
			// Blue hilite
			
			let isKeyWindow = true //controlView.window?.isKeyWindow ?? false
			
			if isEnabled && isKeyWindow
			{
				self.hiliteColor.set()
				NSUIRectFill(arrowBox)
			}
			
			// Arrows
			
			self.drawArrows(in:arrowBox)
			
			// Frame
			
			self.strokeColor.set()
			path.stroke()
//		}
//
//		// Light mode is okay, so we'll let the system do it
//
//		else
//		{
//			super.drawBorderAndBackground(withFrame:cellFrame, in:controlView)
//		}
    }
	
	func drawArrows(in rect:CGRect)
	{
		let l = CGFloat(3.5)
		let d = CGFloat(2)
		
		let x1 = rect.midX - l
		let x2 = rect.midX
		let x3 = rect.midX + l
		let y1 = rect.midY - d - l
		let y2 = rect.midY - d
		let y3 = rect.midY + d
		let y4 = rect.midY + d + l
		
		let path = NSBezierPath()
		path.lineWidth = 1.5
		path.lineJoinStyle = .round
		path.lineCapStyle = .round
		
		path.move(to:CGPoint(x1,y2))
		path.line(to:CGPoint(x2,y1))
		path.line(to:CGPoint(x3,y2))
		path.move(to:CGPoint(x1,y3))
		path.line(to:CGPoint(x2,y4))
		path.line(to:CGPoint(x3,y3))
		
		NSColor.white.set()
		path.stroke()
	}
}


//----------------------------------------------------------------------------------------------------------------------
