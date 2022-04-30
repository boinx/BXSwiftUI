//**********************************************************************************************************************
//
//  BXFloatEditView.swift
//	A view to edit a single Float property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXFloatEditView : View
{
	// Params
	
	private var label:String
	private var value:Binding<Float>
	private var formatter:Formatter? = nil

	// Init
	
	public init(label:String = "", value:Binding<Float>, formatter:Formatter? = nil)
	{
		self.label = label
		self.value = value
		self.formatter = formatter
	}
	
	// Build View
	
	public var body: some View
	{
		BXLabelView(label:label, alignment:.leading)
		{
			BXTextField(value:self.value, formatter:self.formatter)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
