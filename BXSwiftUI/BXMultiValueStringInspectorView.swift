//**********************************************************************************************************************
//
//  BXMultiValueStringInspectorView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Inspector view for multiple values of String

public struct BXMultiValueStringInspectorView : View
{
	// Params
	
	private var label:String = ""
	private var values:Binding<Set<String>>
	private var statusHandler:BXTextFieldStatusHandler? = nil

	// Environment
	
	@Environment(\.controlSize) private var controlSize

	private var idealHeight:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 14
			case .small: 		return 14
			case .mini: 		return 14
			@unknown default: 	return 14
		}
	}
	// Init
	
	public init(label:String = "", values:Binding<Set<String>>, statusHandler:BXTextFieldStatusHandler? = nil)
	{
		self.label = label
		self.values = values
		self.statusHandler = statusHandler
	}
	
	// Build View
	
    public var body: some View
    {
		BXLabelView(label:label, alignment:.leading)
		{
			BXMultiValueTextField(
				values:self.values,
				alignment:.leading,
				statusHandler:self.statusHandler)
//					.reducedOpacityWhenDisabled()	// Not needed because AppKit already dimmed the control
		}

		// Provide fixed height to avoid layout glitches if BXDisclosureViews follow below
		
		.intrinsicContentSize(height:idealHeight)
	}
}


//----------------------------------------------------------------------------------------------------------------------
