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
	public var label:String = ""
	public var width:Binding<CGFloat>? = nil
	public var values:Binding<Set<Bool>>

	public init(label:String = "", width:Binding<CGFloat>? = nil, values:Binding<Set<Bool>>)
	{
		self.label = label
		self.width = width
		self.values = values
	}
	
	public var body: some View
	{
		BXLabelView(label:label, width:width)
		{
			BXMultiValueToggle(values:self.values, label:"Enabled")
			Spacer()
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


//----------------------------------------------------------------------------------------------------------------------
