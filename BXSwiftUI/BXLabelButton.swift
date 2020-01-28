//**********************************************************************************************************************
//
//  BXLabelButton.swift
//	Builds a Text based button for use in BXLabelViews
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// A Text based button that can be passed as an optional argument to BXLabelView

public struct BXLabelButton : View
{
	private var title:String = ""
	private var isEnabled:Bool
	private var action:()->Void
	
	private var alpha:Double { isEnabled ? 1.0 : 0.33 }
	
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
