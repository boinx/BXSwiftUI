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
	private var value:Binding<T>
	private var height:CGFloat? = nil
	private var alignment:TextAlignment = .leading
	private var formatter:Formatter? = nil
	private var isActiveHandler:(BXTextFieldActiveHandler)? = nil

	private var baseline:CGFloat = 15.0
	@Environment(\.controlSize) var controlSize


	public init(value:Binding<T>, height:CGFloat? = nil, alignment:TextAlignment = .leading, formatter:Formatter? = nil, isActiveHandler:(BXTextFieldActiveHandler)? = nil)
	{
		self.value = value
		self.height = height
		self.alignment = alignment
		self.formatter = formatter
		self.isActiveHandler = isActiveHandler
		
		// If a fixed height was not provided, then choose the height and baseline depending on environment controlSize.
		// Please note that these hardcoded values might possibly changes in future OS versions.
		
		if height == nil
		{
			switch controlSize
			{
				case .regular:
//					self.height = 21.0
					self.baseline = 15.0

				case .small:
//					self.height = 19.0
					self.baseline = 14.0

				case .mini:
//					self.height = 16.0
					self.baseline = 11.0

				@unknown default:
//					self.height = 21.0
					self.baseline = 15.0
			}
		}
	}


	public var body: some View
	{
		BXTextFieldWrapper(value:value, height:height, alignment:alignment, formatter:formatter, isActiveHandler:isActiveHandler)

			// Apply size specific alignment for the first baseline
			
			.alignmentGuide(.firstTextBaseline, computeValue:{ _ in self.baseline })
	}
}


//----------------------------------------------------------------------------------------------------------------------
