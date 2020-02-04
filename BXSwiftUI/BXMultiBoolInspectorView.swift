//**********************************************************************************************************************
//
//  BXMultiBoolInspectorView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Inspector view for multiple values of Bool

public struct BXMultiBoolInspectorView : View
{
	// Params
	
	public var label:String
	private var width:Binding<CGFloat>?
	private var values:Binding<Set<Bool>>
	private var title:String
	private var alignment:HorizontalAlignment
	
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
		.frame(maxHeight:24.0, alignment:.top)
	}
}


//----------------------------------------------------------------------------------------------------------------------
