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
	private var huggingPriority:NSLayoutConstraint.Priority = .defaultLow
	private var initialAction:(()->Void)? = nil
	private var orderedItems:[BXMenuItemSpec]

	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxColorTheme) private var bxColorTheme
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName
	
	// Init
	
	public init(values:Binding<Set<Int>>, huggingPriority:NSLayoutConstraint.Priority = .defaultLow, initialAction:(()->Void)? = nil, orderedItems:[BXMenuItemSpec])
	{
		self.values = values
		self.huggingPriority = huggingPriority
		self.initialAction = initialAction
		self.orderedItems = orderedItems
	}
	
	// Create the underlying NSPopUpButton
	
	public func makeNSView(context:Context) -> NSPopUpButton
    {
        let popup = NSPopUpButton(frame:.zero)
        
		popup.cell = BXPopUpButtonCell(textCell:popup.title, pullsDown:popup.pullsDown)
		popup.autoenablesItems = false
		popup.target = context.coordinator
		popup.action = #selector(Coordinator.updateValues(with:))
		popup.setContentHuggingPriority(self.huggingPriority, for:.horizontal)
//		popup.setContentCompressionResistancePriority(.defaultLow, for:.horizontal)
		
		return popup
    }

	// Something on the SwiftUI side has changed, so update the state of the NSPopUpButton
	
	public func updateNSView(_ popup:NSPopUpButton, context:Context)
    {
		// If necessary rebuild the menu item of the popup
		
		let identifier = self.identifier(for:orderedItems)
		if identifier != context.coordinator.identifier
		{
			self.rebuildMenuItems(in:popup)
			context.coordinator.identifier = identifier
		}
		
		// Select the current menu item
		
		DispatchQueue.main.async
		{
			self.selectItem(for:self.values.wrappedValue, in:popup)
		}

		// When the color scheme has changes, update the popup colors
		
		self.setColors(of:popup)
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
		item.isHidden = true
		popup.menu?.addItem(item)

		// Add the menu items
		
		if let menu = popup.menu
		{
			NSMenu.addItems(self.orderedItems, to:menu)
		}
	}
    
    
    /// Returns a unique identifier string that can be used to check if the menu items of a popup have changed and need to be updated
	
	func identifier(for items:[BXMenuItemSpec]) -> String
	{
		return items.reduce("")
		{
			switch $1
			{
				case .action(_,let title,_,_): return $0 + title + "\n"
				case .regular(_,let title,_,_): return $0 + title + "\n"
				case .section(let title): return $0 + title + "\n"
				case .divider: return $0 + "-\n"
			}
		}
	}
	
	
    /// Updates the popup colors when the colorScheme changes
    
	private func setColors(of popup:NSPopUpButton)
    {
		guard let cell = popup.cell as? BXPopUpButtonCell else { return }
		cell.fillColor = NSColor(bxColorTheme.fillColor(for:colorScheme, isEnabled:popup.isEnabled, enhanceBy: colorScheme == .dark ? 0.5 : 1.0))
		cell.strokeColor = NSColor(bxColorTheme.strokeColor(for:colorScheme, isEnabled:popup.isEnabled, enhanceBy: colorScheme == .dark ? 1.0 : 0.6))
		cell.hiliteColor = NSColor(bxColorTheme.hiliteColor())
    }


	// The NSPopUpButton side has changed, so update the SwiftUI state
	
	public class Coordinator : NSObject
    {
        var picker:BXMultiValuePicker
		var identifier:String = ""
		
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


	// According to https://stackoverflow.com/questions/51175125/nspopupbutton-nspopupbuttoncell-deprecated
	// drawInterior must be implemented in order for drawBorderAndBackground to work properly. So do not
	// remove this override!
	
	override open func drawInterior(withFrame cellFrame:NSRect, in controlView:NSView)
	{
		super.drawInterior(withFrame:cellFrame, in:controlView)
	}
	
    override open func drawBorderAndBackground(withFrame cellFrame:NSRect, in controlView:NSView)
    {
		// Standard drawing
		
//		super.drawBorderAndBackground(withFrame:cellFrame, in:controlView)
		
		// Custom drawing
		
		NSGraphicsContext.saveGraphicsState()
		defer { NSGraphicsContext.restoreGraphicsState() }
		
		var frame = cellFrame //.insetBy(dx:0.5, dy:0.5)
		
		if self.controlSize == .regular
		{
			frame = cellFrame.insetBy(dx:3, dy:3).offsetBy(dx:0, dy:-1)
		}
		else if self.controlSize == .small
		{
			frame = cellFrame.insetBy(dx:4, dy:3).offsetBy(dx:0, dy:-1)
		}
		
		var arrowBox = frame
		arrowBox.size.width = 16
		arrowBox.origin.x = frame.maxX - 16
		
		let path = NSBezierPath(roundedRect:frame, xRadius:3, yRadius:3)
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
			arrowBox.fill()
		}
		
		// Arrows
		
		self.drawArrows(in:arrowBox)
		
		// Frame
		
		self.strokeColor.set()
		path.stroke()
    }
	
	func drawArrows(in rect:CGRect)
	{
		let l:CGFloat = controlSize == .regular ? 3.5 : 2.5
		let d:CGFloat = controlSize == .regular ? 2.0 : 1.5
		let w:CGFloat = controlSize == .regular ? 1.5 : 1.0
		
		let x1 = rect.midX - l
		let x2 = rect.midX
		let x3 = rect.midX + l
		let y1 = rect.midY - d - l
		let y2 = rect.midY - d
		let y3 = rect.midY + d
		let y4 = rect.midY + d + l

		let path = NSBezierPath()
		path.lineWidth = w
		path.lineJoinStyle = .round
		path.lineCapStyle = .round
		
		path.move(to:CGPoint(x1,y2))
		path.line(to:CGPoint(x2,y1))
		path.line(to:CGPoint(x3,y2))
		path.move(to:CGPoint(x1,y3))
		path.line(to:CGPoint(x2,y4))
		path.line(to:CGPoint(x3,y3))
		
		let alpha:CGFloat = isEnabled ? 1.0 : 0.33
		NSColor(calibratedWhite:1.0, alpha:alpha).set()
		path.stroke()
	}
}


//----------------------------------------------------------------------------------------------------------------------
