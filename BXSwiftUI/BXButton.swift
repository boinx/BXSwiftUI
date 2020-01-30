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
	private var systemName:String?
	private var title:String?
	private var isEnabled:Bool
	private var isBordered:Bool
	private var action:()->Void

	
	public init(systemName:String? = nil, title:String? = nil, isBordered:Bool = false, isEnabled:Bool = true, action:@escaping ()->Void)
	{
		self.systemName = systemName
		self.title = title
		self.isBordered = isBordered
		self.isEnabled = isEnabled
		self.action = action
	}
	
	
	public var body: some View
	{
		let activeColor = isEnabled ? Color.primary : Color.primary.opacity(0.33)
		
		return Button(action:self.action)
		{
			HStack(spacing:4)
			{
				if systemName != nil
				{
					Image(systemName:systemName!).foregroundColor(activeColor)
				}
				
				if title != nil
				{
					Text(title!).foregroundColor(activeColor)
				}
			}
		}
		.buttonStyle(BXStrokedButtonStyle(isBordered))
		.enabled(isEnabled)
	}
}


//----------------------------------------------------------------------------------------------------------------------
