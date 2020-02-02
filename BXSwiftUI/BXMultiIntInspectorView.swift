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
	// Params
	
	private var label:String = ""
	private var width:Binding<CGFloat>? = nil
	private var values:Binding<Set<Int>>
	private var orderedItems:[BXMenuItemSpec] = []

	/// Creates a MultiIntPropertyView with a simple array of enum cases. Menu item names and tags are generated automatically from this enum array.
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, values:Binding<Set<Int>>, orderedItems:[LocalizableIntEnum])
	{
		self.label = label
		self.width = width
		self.values = values
		self.orderedItems = orderedItems.map
		{
			BXMenuItemSpec.regular(icon:nil, title:$0.localizedName, value:$0.intValue)
		}
	}

	/// Creates a MultiIntPropertyView with an array of BXMenuItemSpecs. This provides more flexibility regarding ordering and inserting separators or disabled section names.
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, values:Binding<Set<Int>>, orderedItems:[BXMenuItemSpec])
	{
		self.label = label
		self.width = width
		self.values = values
		self.orderedItems = orderedItems
	}

	// Build the view
	
    public var body: some View
    {
		BXLabelView(label:label, width:width)
		{
			BXMultiValuePicker(values:self.values, orderedItems:self.orderedItems)
				.modifier(StrokedPopupStyle())
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


