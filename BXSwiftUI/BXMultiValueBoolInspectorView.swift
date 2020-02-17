//**********************************************************************************************************************
//
//  BXMultiValueBoolInspectorView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Inspector view for multiple values of Bool

public struct BXMultiValueBoolInspectorView : View
{
	// Params
	
	public var label:String
	private var width:Binding<CGFloat>?
	private var values:Binding<Set<Bool>>
	private var title:String
	private var alignment:HorizontalAlignment
	
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
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, values:Binding<Set<Bool>>, title:String = "", alignment:HorizontalAlignment = .leading)
	{
		self.label = label
		self.width = width
		self.values = values
		self.title = title
		self.alignment = alignment
	}
	
	// Build View
	
	public var body: some View
	{
		BXLabelView(label:label, width:width)
		{
			if self.alignment == .trailing
			{
				Spacer()
			}
			
			BXMultiValueToggle(values:self.values, label:self.title)
			
			if self.alignment == .leading
			{
				Spacer()
			}
		}

		// Provide fixed height to avoid layout glitches if BXDisclosureViews follow below
		
		.intrinsicContentSize(height:idealHeight)
	}
}


//----------------------------------------------------------------------------------------------------------------------