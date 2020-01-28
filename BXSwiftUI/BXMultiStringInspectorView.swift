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
	public var label:String = ""
	public var width:Binding<CGFloat>? = nil
	public var values:Binding<Set<String>>
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, values:Binding<Set<String>>)
	{
		self.label = label
		self.width = width
		self.values = values
	}
	
    public var body: some View
    {
		BXLabelView(label:label, width:width)
		{
			BXMultiValueTextField(values:self.values, height:22.0, alignment:.leading)
			{
				nstextfield,_,_ in
				nstextfield.isBordered = true
				nstextfield.drawsBackground = true
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
