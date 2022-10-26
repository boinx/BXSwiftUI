//**********************************************************************************************************************
//
//  BXSearchField.swift
//	SwiftUI wrapper for NSTextField with custom behavior
//  Copyright ©2020-2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

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
	private var onFocused:((NSSearchField,String)->Void)? = nil
	private var onBegan:((NSSearchField,String)->Void)? = nil
	private var onChanged:((NSSearchField,String)->Void)? = nil
	private var onCommit:((NSSearchField,String)->Void)? = nil
	private var onArrowUpKey:((NSSearchField)->Void)? = nil
	private var onArrowDownKey:((NSSearchField)->Void)? = nil

	// Environment
	
	@Environment(\.controlSize) private var controlSize

	// Init

	public init(value:Binding<String>, placeholderString:String = "", height:CGFloat? = nil, alignment:TextAlignment = .leading, formatter:Formatter? = nil, statusHandler:(BXTextFieldStatusHandler)? = nil, onFocused:((NSSearchField,String)->Void)? = nil, onBegan:((NSSearchField,String)->Void)? = nil, onChanged:((NSSearchField,String)->Void)? = nil, onCommit:((NSSearchField,String)->Void)? = nil, onArrowUpKey:((NSSearchField)->Void)? = nil, onArrowDownKey:((NSSearchField)->Void)? = nil)
	{
		self.value = value
		self.placeholderString = placeholderString
		self.height = height
		self.statusHandler = statusHandler
		self.onFocused = onFocused
		self.onBegan = onBegan
		self.onChanged = onChanged
		self.onCommit = onCommit
		self.onArrowUpKey = onArrowUpKey
		self.onArrowDownKey = onArrowDownKey
	}

	// Build View

	public var body: some View
	{
		BXSearchFieldWrapper(value:value, placeholderString:placeholderString, height:height, statusHandler:statusHandler, onFocused:onFocused, onBegan:onBegan, onChanged:onChanged, onCommit:onCommit, onArrowUpKey:onArrowUpKey, onArrowDownKey:onArrowDownKey)

			// Apply size specific alignment for the first baseline
			
			.alignmentGuide(.firstTextBaseline, computeValue:{ _ in self.baseline })
	}

	/// Returns the baseline for the current size
	
	var baseline:CGFloat
	{
		guard height == nil else { return 15.0 }
		
		switch controlSize
		{
			case .regular:	return 16.0
			case .small:	return 14.0
			case .mini:		return 11.0
			default:		return 15.0
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
