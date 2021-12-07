//**********************************************************************************************************************
//
//  BXSearchField.swift
//	SwiftUI wrapper for NSTextField with custom behavior
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public struct  BXSearchField : View
{
	// Params
	
	private var value:Binding<String>
	private var placeholderString:String = ""
	private var height:CGFloat? = nil
	private var statusHandler:(BXTextFieldStatusHandler)? = nil
	private var onBegan:((NSSearchField,String)->Void)? = nil
	private var onChanged:((NSSearchField,String)->Void)? = nil
	private var onCommit:((NSSearchField,String)->Void)? = nil

	// Environment
	
	@Environment(\.controlSize) private var controlSize

	// Internal
	
	private var baseline:CGFloat = 15.0
	
	// Build View

	public init(value:Binding<String>, placeholderString:String = "", height:CGFloat? = nil, alignment:TextAlignment = .leading, formatter:Formatter? = nil, statusHandler:(BXTextFieldStatusHandler)? = nil, onBegan:((NSSearchField,String)->Void)? = nil, onChanged:((NSSearchField,String)->Void)? = nil, onCommit:((NSSearchField,String)->Void)? = nil)
	{
		self.value = value
		self.placeholderString = placeholderString
		self.height = height
		self.statusHandler = statusHandler
		self.onBegan = onBegan
		self.onChanged = onChanged
		self.onCommit = onCommit
		
		// If a fixed height was not provided, then choose the height and baseline depending on environment controlSize.
		// Please note that these hardcoded values might possibly changes in future OS versions.
		
		if height == nil
		{
			switch controlSize
			{
				case .regular:
//					self.height = 21.0
					self.baseline = 16.0

				case .small:
//					self.height = 19.0
					self.baseline = 14.0

				case .mini:
//					self.height = 16.0
					self.baseline = 11.0

				default:
//					self.height = 21.0
					self.baseline = 15.0
			}
		}
	}


	public var body: some View
	{
		BXSearchFieldWrapper(value:value, placeholderString:placeholderString, height:height, statusHandler:statusHandler, onBegan:onBegan, onChanged:onChanged, onCommit:onCommit)

			// Apply size specific alignment for the first baseline
			
			.alignmentGuide(.firstTextBaseline, computeValue:{ _ in self.baseline })
	}
}


//----------------------------------------------------------------------------------------------------------------------
