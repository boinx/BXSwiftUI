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
	private var statusHandler:(BXTextViewStatusHandler)? = nil

	// Init
	
	public init(label:String = "", value:Binding<NSAttributedString>, statusHandler:(BXTextViewStatusHandler)? = nil)
	{
		self.label = label
		self.value = value
		self.statusHandler = statusHandler
	}
	
	// Build View
	
	public var body: some View
	{
		BXLabelView(label:label, alignment:.leading)
		{
			BXTextView(value:value, statusHandler:statusHandler)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif	
