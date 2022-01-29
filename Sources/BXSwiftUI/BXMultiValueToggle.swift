//**********************************************************************************************************************
//
//  BXMultiValueToggle.swift
//	SwiftUI wrapper for a checkbox that supports multiple values (via mixed state)
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public struct BXMultiValueToggle : View
{
	// Params
	
	private var values:Binding<Set<Bool>>
	private var label:String = ""
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.controlSize) private var controlSize
	@Environment(\.hasMultipleValues) private var hasMultipleValues

	// Init
	
	public init(values:Binding<Set<Bool>>, label:String = "", onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.values = values
		self.label = label
		self.onBegan = onBegan
		self.onEnded = onEnded
	}
	
	// Build View
	
	public var body: some View
	{
		Toggle(isOn:self.valueBinding)
		{
			Text(label)
		}
		.hasMultipleValues(self.values.wrappedValue.count > 1)
	}

	// Custom Binding
	
	private var valueBinding:Binding<Bool>
	{
		 Binding<Bool>(
		 
			get:
			{
				if self.values.wrappedValue.count > 1
				{
					return true
				}
				else if let value = self.values.wrappedValue.first
				{
					return value
				}
				
				return false
			},
			
			set:
			{
				self.onBegan?()
				self.values.wrappedValue = Set([$0])
				self.onEnded?()
			})
	}

}


//----------------------------------------------------------------------------------------------------------------------
