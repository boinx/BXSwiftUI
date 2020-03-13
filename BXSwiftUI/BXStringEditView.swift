//**********************************************************************************************************************
//
//  BXStringEditView.swift
//	A view to edit a single String property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXStringEditView : View
{
	// Params
	
	private var label:String = ""
	private var value:Binding<String>

	// Init
	
	public init(label:String = "", value:Binding<String>)
	{
		self.label = label
		self.value = value
	}
	
	// Build View
	
	public var body: some View
	{
		BXLabelView(label:label, alignment:.leading)
		{
			BXTextField(value:self.value)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

