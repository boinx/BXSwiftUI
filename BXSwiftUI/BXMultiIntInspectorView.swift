//**********************************************************************************************************************
//
//  BXIntPropertyView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Inspector view for multiple values of Int

public struct BXMultiIntInspectorView : View
{
	private var label:String = ""
	private var width:Binding<CGFloat>? = nil
	private var values:Binding<Set<Int>>
	private var orderedItems:[BXMultiValuePicker.Item] = []

	/// Creates a MultiIntPropertyView with a simple array of enum cases. Menu item names and tags are generated automatically from this enum array.
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, values:Binding<Set<Int>>, orderedItems:[LocalizableIntEnum])
	{
		self.label = label
		self.width = width
		self.values = values
		self.orderedItems = orderedItems.map
		{
			BXMultiValuePicker.Item.regular(icon:nil, title:$0.localizedName, value:$0.intValue)
		}
	}

	/// Creates a MultiIntPropertyView with the provided closure. This closure provides more flexibility regarding ordering and inserting separators or disabled section names.
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, values:Binding<Set<Int>>, orderedItems:()->[BXMultiValuePicker.Item])
	{
		self.label = label
		self.width = width
		self.values = values
		self.orderedItems = orderedItems()
	}

	var isUnique:Bool
	{
		values.wrappedValue.count < 2
	}
	
    public var body: some View
    {
		BXLabelView(label:label, width:width)
		{
			BXMultiValuePicker(values:self.values, orderedItems:self.orderedItems)
				.environment(\.isEnabled, self.values.wrappedValue.count>0)
				.modifier(StrokedPopupStyle())
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


