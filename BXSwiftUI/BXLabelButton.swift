//**********************************************************************************************************************
//
//  BXLabelButton.swift
//	Builds a Text based button for use in BXLabelViews
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXLabelButton : View
{
	var title:String = ""
	var isEnabled:Bool
	var action:()->Void
	
	var alpha:Double { isEnabled ? 1.0 : 0.33 }
	
	public init(title:String = "", isEnabled:Bool, action:@escaping ()->Void)
	{
		self.title = title
		self.isEnabled = isEnabled
		self.action = action
	}
	
	public var body: some View
	{
		Text(title)
			.font(.body)
			.disabled(!self.isEnabled)
			.opacity(self.alpha)
			.onTapGesture
			{
				self.action()
			}
	}
}


//----------------------------------------------------------------------------------------------------------------------
