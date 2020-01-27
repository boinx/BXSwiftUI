//**********************************************************************************************************************
//
//  BXStringEditView.swift
//	A view to edit a single String property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXStringEditView : View
{
	private var label:String
	private var labelWidth:Binding<CGFloat>? = nil
	private var value:Binding<String>


	public init(label:String, labelWidth:Binding<CGFloat>? = nil, value:Binding<String>)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
	}
	
	
	public var body: some View
	{
		HStack
		{
			if label.count > 0
			{
				BXPropertyLabel(label, width:labelWidth)
			}
			
			BXCustomTextField(value:value)
			{
				(nstextfield,_,_) in
				nstextfield.isBordered = true
				nstextfield.drawsBackground = true
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

