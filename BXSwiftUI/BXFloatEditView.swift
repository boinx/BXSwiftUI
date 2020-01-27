//**********************************************************************************************************************
//
//  BXFloatEditView.swift
//	A view to edit a single Float property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXFloatEditView : View
{
	private var label:String
	private var labelWidth:Binding<CGFloat>? = nil
	private var value:Binding<Float>
	private var formatter:Formatter? = nil


	public init(label:String, labelWidth:Binding<CGFloat>? = nil, value:Binding<Float>, formatter:Formatter? = nil)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
		self.formatter = formatter
	}
	
	
	public var body: some View
	{
		HStack
		{
			if label.count > 0
			{
				BXPropertyLabel(label, width:labelWidth)
			}
			
			BXCustomTextField(value:value, formatter:formatter)
			{
				(nstextfield,_,_) in
				nstextfield.isBordered = true
				nstextfield.drawsBackground = true
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

