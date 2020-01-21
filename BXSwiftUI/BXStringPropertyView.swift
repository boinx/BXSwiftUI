//**********************************************************************************************************************
//
//  BXStringPropertyView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Property view for a single value String?

public struct BXStringPropertyView : View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>? = nil
	public var value:Binding<String?>

	public init(label:String = "", labelWidth:Binding<CGFloat>? = nil, value:Binding<String?>)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
	}
	
    public var body: some View
    {
		HStack
		{
			BXPropertyLabel(label, width:labelWidth)
				
			BXCustomTextField(value:value, height:22.0, alignment:.leading)
			{
				(nstextfield,_,_) in
				nstextfield.isBordered = true
				nstextfield.drawsBackground = true
			}
		}
	}
}


/// Property view for multiple values of String

public struct BXMultiStringPropertyView : View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>? = nil
	public var values:Binding<Set<String>>
	
	public init(label:String = "", labelWidth:Binding<CGFloat>? = nil, values:Binding<Set<String>>)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.values = values
	}
	
    public var body: some View
    {
		HStack
		{
			BXPropertyLabel(label, width:labelWidth)
				
			BXMultiValueTextField(values:values, height:22.0, alignment:.leading)
			{
				nstextfield,_,_ in
				nstextfield.isBordered = true
				nstextfield.drawsBackground = true
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
