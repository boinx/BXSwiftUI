//**********************************************************************************************************************
//
//  BXTextField.swift
//	SwiftUI wrapper for NSTextField with custom behavior
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public struct  BXTextField<T> : View
{
	// Params
	
	private var value:Binding<T>
	private var height:CGFloat? = nil
	private var alignment:TextAlignment = .leading
	private var placeholderString:String? = nil
	private var formatter:Formatter? = nil
	private var selectAllOnMouseDown = true
	private var allowSpaceKey = false
	private var statusHandler:(BXTextFieldStatusHandler)? = nil
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil

	// Environment
	
	@Environment(\.controlSize) private var controlSize

	// Internal
	
	private var baseline:CGFloat = 15.0
	
	// Build View

	public init(value:Binding<T>, height:CGFloat? = nil, alignment:TextAlignment = .leading, placeholderString:String? = nil, formatter:Formatter? = nil, selectAllOnMouseDown:Bool = true, allowSpaceKey:Bool = false,statusHandler:(BXTextFieldStatusHandler)? = nil, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.value = value
		self.height = height
		self.alignment = alignment
		self.placeholderString = placeholderString
		self.formatter = formatter
		self.selectAllOnMouseDown = selectAllOnMouseDown
		self.allowSpaceKey = allowSpaceKey
		self.statusHandler = statusHandler
		self.onBegan = onBegan
		self.onEnded = onEnded
		
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
		BXTextFieldWrapper(value:value, height:height, alignment:alignment, placeholderString:placeholderString, formatter:formatter, selectAllOnMouseDown:selectAllOnMouseDown, allowSpaceKey:allowSpaceKey, statusHandler:statusHandler)

			// Apply size specific alignment for the first baseline
			
			.alignmentGuide(.firstTextBaseline, computeValue:{ _ in self.baseline })
			
			// This makes sure that tabbing order (nextKeyViewLoop) is correct (top to bottom)
			
			.focusable()
	}
}


//----------------------------------------------------------------------------------------------------------------------
