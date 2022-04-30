//**********************************************************************************************************************
//
//  BXIntEditView.swift
//	A view to edit a single Int property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXIntEditView : View
{
	// Params
	
	private var label:String
	private var value:Binding<Int>
	private var formatter:Formatter? = nil

	// Init
	
	public init(label:String = "", value:Binding<Int>, formatter:Formatter? = .intFormatter)
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
