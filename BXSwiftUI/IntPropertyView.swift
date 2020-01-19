//**********************************************************************************************************************
//
//  IntPropertyView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Property view for a single value Int

public struct IntPropertyView : View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>
	public var value:Binding<Int>
	public var allCases:[LocalizableIntEnum] = []
	
	public init(label:String = "", labelWidth:Binding<CGFloat>, value:Binding<Int>, allCases:[LocalizableIntEnum])
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
		self.allCases = allCases
	}
	
    public var body: some View
    {
		HStack
		{
			PropertyLabel(label, width:labelWidth.wrappedValue)

			Picker(selection:value, label:Text(""))
			{
				ForEach(allCases, id:\.intValue)
				{
					Text($0.localizedName).tag($0.intValue)
				}
			}
			.labelsHidden()
		}
	}
}


/// Property view for multiple values of Int

public struct MultiIntPropertyView : View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>
	public var values:Binding<Set<Int>>
	public var allCases:[LocalizableIntEnum] = []
	
	public init(label:String = "", labelWidth:Binding<CGFloat>, values:Binding<Set<Int>>, allCases:[LocalizableIntEnum])
	{
		self.label = label
		self.labelWidth = labelWidth
		self.values = values
		self.allCases = allCases
	}

	var isUnique:Bool
	{
		values.wrappedValue.count < 2
	}
	
    public var body: some View
    {
		HStack
		{
			PropertyLabel(label, width:labelWidth.wrappedValue)
			MultiValuePicker(values:values, allCases:allCases)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


