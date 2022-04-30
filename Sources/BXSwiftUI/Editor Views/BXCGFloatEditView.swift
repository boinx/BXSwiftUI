//**********************************************************************************************************************
//
//  BXCGFloatEditView.swift
//	A view to edit a single CGFloat property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXCGFloatEditView : View
{
	// Params
	
	private var label:String
	private var value:Binding<CGFloat>
	private var formatter:Formatter? = nil

	// Init
	
	public init(label:String = "", value:Binding<CGFloat>, formatter:Formatter? = nil)
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
