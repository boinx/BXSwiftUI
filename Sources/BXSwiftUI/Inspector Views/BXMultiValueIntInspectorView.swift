//**********************************************************************************************************************
//
//  BXMultiValueIntPropertyView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Inspector view for multiple values of Int

public struct BXMultiValueIntInspectorView : View
{
	// Params
	
	private var label:String = ""
	private var values:Binding<Set<Int>>
	private var orderedItems:[BXMenuItemSpec] = []
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil

	// Environment
	
	@Environment(\.controlSize) private var controlSize:ControlSize
	@Environment(\.isEnabled) private var isEnabled:Bool

	private var idealHeight:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 18
			case .small: 		return 18
			case .mini: 		return 18
			default: 	return 18
		}
	}
	
	/// Creates a MultiIntPropertyView with a simple array of enum cases. Menu item names and tags are generated automatically from this enum array.
	
	public init(label:String = "", values:Binding<Set<Int>>, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil, orderedItems:[LocalizableIntEnum])
	{
		self.label = label
		self.values = values
		self.onBegan = onBegan
		self.onEnded = onEnded
		self.orderedItems = orderedItems.map
		{
			BXMenuItemSpec.regular(icon:nil, title:$0.localizedName, value:$0.intValue)
		}
	}

	/// Creates a MultiIntPropertyView with an array of BXMenuItemSpecs. This provides more flexibility regarding ordering and inserting separators or disabled section names.
	
	public init(label:String = "", values:Binding<Set<Int>>, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil, orderedItems:[BXMenuItemSpec])
	{
		self.label = label
		self.values = values
		self.onBegan = onBegan
		self.onEnded = onEnded
		self.orderedItems = orderedItems
	}

	// Build the view
	
    public var body: some View
    {
		BXLabelView(label:label, alignment:.leading)
		{
			BXMultiValuePicker(
				values:self.values,
				onBegan:self.onBegan,
				onEnded:self.onEnded,
				orderedItems:self.orderedItems)
					//.reducedOpacityWhenDisabled()	// Not needed because AppKit already dimmed the control
		}
		
		// Provide fixed height to avoid layout glitches if BXDisclosureViews follow below
		
		.intrinsicContentSize(height:idealHeight)
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
