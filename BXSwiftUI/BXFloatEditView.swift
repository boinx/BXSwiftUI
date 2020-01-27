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
	private var width:Binding<CGFloat>? = nil
	private var value:Binding<Float>
	private var formatter:Formatter? = nil


	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<Float>, formatter:Formatter? = nil)
	{
		self.label = label
		self.width = width
		self.value = value
		self.formatter = formatter
	}
	
	
	public var body: some View
	{
		BXLabelView(label:label, width:width)
		{
			BXCustomTextField(value:self.value, formatter:self.formatter)
			{
				(nstextfield,_,_) in
				nstextfield.isBordered = true
				nstextfield.drawsBackground = true
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

