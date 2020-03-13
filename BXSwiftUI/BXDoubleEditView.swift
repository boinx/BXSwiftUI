//**********************************************************************************************************************
//
//  BXDoubleEditView.swift
//	A view to edit a single Double property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXDoubleEditView : View
{
	// Params
	
	private var label:String
	private var value:Binding<Double>
	private var formatter:Formatter? = nil

	// Init
	
	public init(label:String = "", value:Binding<Double>, formatter:Formatter? = .doubleFormatter)
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

