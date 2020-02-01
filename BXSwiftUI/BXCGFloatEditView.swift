//**********************************************************************************************************************
//
//  BXCGFloatEditView.swift
//	A view to edit a single CGFloat property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXCGFloatEditView : View
{
	private var label:String
	private var width:Binding<CGFloat>? = nil
	private var value:Binding<CGFloat>
	private var formatter:Formatter? = nil


	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<CGFloat>, formatter:Formatter? = nil)
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
			BXTextField(value:self.value, height:21, formatter:self.formatter)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

