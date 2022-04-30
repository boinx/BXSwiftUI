//**********************************************************************************************************************
//
//  BXPicker.swift
//	SwiftUI wrapper for a NSPopUpButton
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


// BXPicker is implemented as a specialized version on top BXMultiValuePicker, which is the more general and more
// functionally capable version.

public struct BXPicker : View
{
	// Params
	
	private var value:Binding<Int>
	private var huggingPriority:NSLayoutConstraint.Priority = .defaultLow
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil
	private var orderedItems:[BXMenuItemSpec]

	// Init
	
	public init(value:Binding<Int>, huggingPriority:NSLayoutConstraint.Priority = .defaultLow, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil, orderedItems:[BXMenuItemSpec])
	{
		self.value = value
		self.huggingPriority = huggingPriority
		self.onBegan = onBegan
		self.onEnded = onEnded
		self.orderedItems = orderedItems
	}
	
	// Build View
	
	public var body: some View
	{
		return BXMultiValuePicker(values:multiValueBinding, huggingPriority:huggingPriority, onBegan:onBegan, onEnded:onEnded, orderedItems:orderedItems)
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

#endif
