//**********************************************************************************************************************
//
//  BXToggle.swift
//	SwiftUI wrapper for a checkbox
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public struct BXToggle : View
{
	// Params
	
	private var value:Binding<Bool>
	private var label:String = ""
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.controlSize) private var controlSize
	@Environment(\.bxUndoManagerProvider) private var undoManagerProvider
	@Environment(\.bxUndoName) private var undoName
	@Environment(\.bxAccessibilityIdentifier) private var bxAccessibilityIdentifier

	// Init
	
	public init(value:Binding<Bool>, label:String = "", onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.value = value
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
		.bxAccessibilityIdentifier(bxAccessibilityIdentifier ?? "Unknown")
	}

	// Custom Binding
	
	private var valueBinding:Binding<Bool>
	{
		 Binding<Bool>(
		 
			get:
			{
				self.value.wrappedValue
			},
			
			set:
			{
				self.onBegan?()
				self.value.wrappedValue = $0
				self.onEnded?()
				self.undoManagerProvider.undoManager?.setActionName(self.undoName)
			})
	}

}


//----------------------------------------------------------------------------------------------------------------------


#endif
