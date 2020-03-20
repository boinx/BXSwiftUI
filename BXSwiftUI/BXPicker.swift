//**********************************************************************************************************************
//
//  BXPicker.swift
//	SwiftUI wrapper for a NSPopUpButton
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


// BXPicker is implemented as a specialized version on top BXMultiValuePicker, which is the more general and more
// functionally capable version.

public struct BXPicker : View
{
	// Params
	
	private var value:Binding<Int>
	private var initialAction:(()->Void)? = nil
	private var orderedItems:[BXMenuItemSpec]

	// Init
	
	public init(value:Binding<Int>, initialAction:(()->Void)? = nil, orderedItems:[BXMenuItemSpec])
	{
		self.value = value
		self.initialAction = initialAction
		self.orderedItems = orderedItems
	}
	
	// Build View
	
	public var body: some View
	{
		BXMultiValuePicker(values:multiValueBinding, initialAction:initialAction, orderedItems:orderedItems)
	}

	// Convert between Int and Set<Int>
	
	private var multiValueBinding:Binding<Set<Int>>
	{
		return Binding<Set<Int>>(
			get:{ Set([self.value.wrappedValue]) },
			set:{ self.value.wrappedValue = $0.first ?? 0 }
		)
	}
}


//----------------------------------------------------------------------------------------------------------------------
