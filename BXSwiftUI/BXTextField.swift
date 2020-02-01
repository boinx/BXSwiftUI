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


	public init(value:Binding<T>, height:CGFloat? = nil, alignment:TextAlignment = .leading, formatter:Formatter? = nil, isActiveHandler:(BXTextFieldActiveHandler)? = nil)
	{
		self.value = value
		self.height = height
		self.alignment = alignment
		self.formatter = formatter
		self.isActiveHandler = isActiveHandler
	}


	public var body: some View
	{
		BXTextFieldWrapper(value:value, height:height, alignment:alignment, formatter:formatter, isActiveHandler:isActiveHandler)

			.alignmentGuide(.firstTextBaseline, computeValue:{ _ in 15.0 })
	}
}


//----------------------------------------------------------------------------------------------------------------------
