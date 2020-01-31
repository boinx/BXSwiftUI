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
	private var width:Binding<CGFloat>? = nil
	private var value:Binding<Int>
	private var formatter:Formatter? = nil


	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<Int>, formatter:Formatter? = nil)
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
			BXTextField(value:self.value, formatter:self.formatter)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

