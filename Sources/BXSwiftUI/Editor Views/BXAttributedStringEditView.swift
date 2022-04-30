//**********************************************************************************************************************
//
//  BXAttributedStringEditView.swift
//	A view to edit a single NSAttributedString property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXAttributedStringEditView : View
{
	// Params
	
	private var label:String = ""
	private var value:Binding<NSAttributedString>

	// Init
	
	public init(label:String = "", value:Binding<NSAttributedString>)
	{
		self.label = label
		self.value = value
	}
	
	// Build View
	
	public var body: some View
	{
		BXLabelView(label:label, alignment:.leading)
		{
			BXTextView(value:self.value)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif	
