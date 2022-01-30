//**********************************************************************************************************************
//
//  BXButton.swift
//	A custom button that displays an SF Symbols icon
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXButton : View
{
	// Params
	
	private var systemName:String?
	private var title:String?
	private var isEnabled:Bool
	private var isBordered:Bool
	private var action:()->Void

	// Environment
	
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// Init
	
	public init(systemName:String? = nil, title:String? = nil, isBordered:Bool = false, isEnabled:Bool = true, action:@escaping ()->Void)
	{
		self.systemName = systemName
		self.title = title
		self.isBordered = isBordered
		self.isEnabled = isEnabled
		self.action = action
	}
	
	// Build View
	
	public var body: some View
	{
		// Button color depends on isEnabled state
		
		let activeColor = isEnabled ? Color.primary : Color.primary.opacity(0.33)
		
		// Define the button with its contents
		
		let closure =
		{
			self.action()
			self.undoManager?.setActionName(self.undoName)
		}
		
		let button = Button(action:closure)
		{
			HStack(spacing:4)
			{
				if systemName != nil
				{
					Image(systemName:systemName!)
				}
				
				if title != nil
				{
					Text(title!)
				}
			}
		}
		.enabled(isEnabled)
		
		// If a border is desired, then use the global buttonStyle (Environment), otherwise override
		// with BorderlessButtonStyle.
		
		return Group
		{
			if isBordered
			{
				button
			}
			else
			{
				button.foregroundColor(activeColor).buttonStyle(BorderlessButtonStyle())
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
