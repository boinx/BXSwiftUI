//**********************************************************************************************************************
//
//  BXIntEditView.swift
//	A view to edit a single Int property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXIntEditView : View
{
	private var label:String
	private var labelWidth:Binding<CGFloat>? = nil
	private var value:Binding<Int>
	private var formatter:Formatter? = nil

	public init(label:String, labelWidth:Binding<CGFloat>? = nil, value:Binding<Int>, formatter:Formatter? = nil)
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
			BXPropertyLabel(label, width:labelWidth)

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

