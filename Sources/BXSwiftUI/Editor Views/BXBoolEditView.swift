//**********************************************************************************************************************
//
//  BXBoolEditView.swift
//	A view to edit a single Bool property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXBoolEditView : View
{
	// Params
	
	private var label:String
	private var value:Binding<Bool>

	// Init

	public init(label:String = "", value:Binding<Bool>)
	{
		self.label = label
		self.value = value
	}
	
	// Build View
	
	public var body: some View
	{
		BXLabelView(label:label, alignment:.leading)
		{
			Toggle("", isOn:self.value).labelsHidden()
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
