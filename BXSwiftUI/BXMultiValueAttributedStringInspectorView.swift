//**********************************************************************************************************************
//
//  BXMultiValueAttributedStringInspectorView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Inspector view for multiple values of NSAttributedString

public struct BXMultiValueAttributedStringInspectorView : View
{
	// Params
	
	private var label:String = ""
	private var values:Binding<Set<NSAttributedString>>
	private var statusHandler:BXTextViewStatusHandler? = nil

	// Init
	
	public init(label:String = "", values:Binding<Set<NSAttributedString>>, statusHandler:BXTextViewStatusHandler? = nil)
	{
		self.label = label
		self.values = values
		self.statusHandler = statusHandler
	}
	
	// Build the view
	
    public var body: some View
    {
		BXLabelView(label:label, alignment:.leading)
		{
			BXMultiValueTextView(
				values:self.values,
				statusHandler:self.statusHandler)
//					.reducedOpacityWhenDisabled()	// Not needed because AppKit already dim the control
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
