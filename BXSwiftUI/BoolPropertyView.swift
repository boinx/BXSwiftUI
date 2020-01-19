//**********************************************************************************************************************
//
//  BoolPropertyView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Property view for a single value Bool

public struct BoolPropertyView : View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>? = nil
	public var value:Binding<Bool>

	public init(label:String = "", labelWidth:Binding<CGFloat>? = nil, value:Binding<Bool>)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
	}
	
	public var body: some View
	{
		HStack
		{
			PropertyLabel(label, width:labelWidth)
			Toggle("Enabled", isOn:value)
			Spacer()
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


/// Property view for multiple values of Bool

public struct MultiBoolPropertyView : View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>? = nil
	public var values:Binding<Set<Bool>>

	public init(label:String = "", labelWidth:Binding<CGFloat>? = nil, values:Binding<Set<Bool>>)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.values = values
	}
	
	public var body: some View
	{
		HStack
		{
			PropertyLabel(label, width:labelWidth)
			MultiValueToggle(values:values, label:"Enabled")
			Spacer()
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


//----------------------------------------------------------------------------------------------------------------------
