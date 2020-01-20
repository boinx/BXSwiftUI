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
	private var label:String = ""
	private var labelWidth:Binding<CGFloat>? = nil
	private var value:Binding<Int>
	private var allCases:[LocalizableIntEnum] = []
	
	public init(label:String = "", labelWidth:Binding<CGFloat>? = nil, value:Binding<Int>, allCases:[LocalizableIntEnum])
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
			PropertyLabel(label, width:labelWidth)

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
	private var label:String = ""
	private var labelWidth:Binding<CGFloat>? = nil
	private var values:Binding<Set<Int>>
	private var orderedItems:[MultiValuePicker.Item] = []

	/// Creates a MultiIntPropertyView with a simple array of enum cases. Menu item names and tags are generated automatically from this enum array.
	
	public init(label:String = "", labelWidth:Binding<CGFloat>? = nil, values:Binding<Set<Int>>, orderedItems:[LocalizableIntEnum])
	{
		self.label = label
		self.labelWidth = labelWidth
		self.values = values
		self.orderedItems = orderedItems.map
		{
			MultiValuePicker.Item.regular(icon:nil, title:$0.localizedName, value:$0.intValue)
		}
	}

	/// Creates a MultiIntPropertyView with the provided closure. This closure provides more flexibility regarding ordering and inserting separators or disabled section names.
	
	public init(label:String = "", labelWidth:Binding<CGFloat>? = nil, values:Binding<Set<Int>>, orderedItems:()->[MultiValuePicker.Item])
	{
		self.label = label
		self.labelWidth = labelWidth
		self.values = values
		self.orderedItems = orderedItems()
	}

	var isUnique:Bool
	{
		values.wrappedValue.count < 2
	}
	
    public var body: some View
    {
		HStack
		{
			PropertyLabel(label, width:labelWidth)
			MultiValuePicker(values:values, orderedItems:orderedItems)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


