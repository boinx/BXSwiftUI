//**********************************************************************************************************************
//
//  BXMultiStringInspectorView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Inspector view for multiple values of String

public struct BXMultiStringInspectorView : View
{
	// Params
	
	private var label:String = ""
	private var width:Binding<CGFloat>? = nil
	private var values:Binding<Set<String>>
	private var statusHandler:BXTextFieldStatusHandler? = nil

	// Init
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, values:Binding<Set<String>>, statusHandler:BXTextFieldStatusHandler? = nil)
	{
		self.label = label
		self.width = width
		self.values = values
		self.statusHandler = statusHandler
	}
	
	// Build View
	
    public var body: some View
    {
		BXLabelView(label:label, width:width)
		{
			BXMultiValueTextField(values:self.values, alignment:.leading, statusHandler:self.statusHandler)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
