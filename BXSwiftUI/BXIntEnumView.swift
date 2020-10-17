//**********************************************************************************************************************
//
//  BXIntEnumView.swift
//	A popup menu to change an Int property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXIntEnumView : View
{
	// Params
	
	private var label:String = ""
	private var value:Binding<Int>
	private var orderedItems:[BXMenuItemSpec] = []

	// Custom binding to make it compatible with underlying BXMultiValuePicker
	
	private var multiValueBinding:Binding<Set<Int>>
	{
		Binding<Set<Int>>(
			get: { Set([self.value.wrappedValue]) },
			set: { self.value.wrappedValue = $0.first ?? 0 }
		)
	}

	/// Creates a BXIntEnumView with a simple array of enum cases. Menu item names and tags are generated automatically from this enum array.
	
	public init(label:String = "", value:Binding<Int>, orderedItems:[LocalizableIntEnum])
	{
		self.label = label
		self.value = value
		self.orderedItems = orderedItems.map
		{
			BXMenuItemSpec.regular(icon:nil, title:$0.localizedName, value:$0.intValue)
		}
	}

	/// Creates a BXIntEnumView with an array of BXMenuItemSpecs. This brings more flexibility regarding ordering and inserting separators or disabled section names.
	
	public init(label:String = "", value:Binding<Int>, orderedItems:[BXMenuItemSpec])
	{
		self.label = label
		self.value = value
		self.orderedItems = orderedItems
	}

	// Build View
	
    public var body: some View
    {
		BXLabelView(label:label, alignment:.leading)
		{
			BXMultiValuePicker(values:self.multiValueBinding, orderedItems:self.orderedItems)
				.environment(\.isEnabled, true)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

