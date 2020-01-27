//**********************************************************************************************************************
//
//  BXBoolEditView.swift
//	A view to edit a single Bool property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXBoolEditView : View
{
	private var label:String
	private var labelWidth:Binding<CGFloat>? = nil
	private var value:Binding<Bool>


	public init(label:String, labelWidth:Binding<CGFloat>? = nil, value:Binding<Bool>)
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
			
			Toggle("", isOn:value).labelsHidden()
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

