//**********************************************************************************************************************
//
//  BXTextField.swift
//	SwiftUI wrapper for NSTextField with custom behavior
//  Copyright ©2020-2026 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

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
	private var onChanged:((String)->Void)? = nil
	private var onEnded:(()->Void)? = nil

	// Environment
	
	@Environment(\.controlSize) private var controlSize
	
	// Init

	public init(value:Binding<T>, height:CGFloat? = nil, alignment:TextAlignment = .leading, placeholderString:String? = nil, formatter:Formatter? = nil, selectAllOnMouseDown:Bool = true, allowSpaceKey:Bool = false,statusHandler:(BXTextFieldStatusHandler)? = nil, onBegan:(()->Void)? = nil, onChanged:((String)->Void)? = nil, onEnded:(()->Void)? = nil)
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
		self.onChanged = onChanged
		self.onEnded = onEnded
	}

	// Build View

	public var body: some View
	{
		BXTextFieldWrapper(value:value, height:height, alignment:alignment, placeholderString:placeholderString, formatter:formatter, selectAllOnMouseDown:selectAllOnMouseDown, allowSpaceKey:allowSpaceKey, statusHandler:statusHandler, onBegan:onBegan, onChanged:onChanged, onEnded:onEnded)

			// Apply size specific alignment for the first baseline
			
			.alignmentGuide(.firstTextBaseline, computeValue:{ _ in self.baseline })
	}
	
	/// Returns the baseline for the current size
	
	var baseline:CGFloat
	{
		guard height == nil else { return 15.0 }
		
		switch controlSize
		{
			case .regular:
			
				if #available(macOS 26,*), Bundle.SDKVersionMajor >= 26
				{
					return 16.0
				}
				else
				{
					return 16.0
				}
				
			case .small:	return 14.0
			case .mini:		return 11.0
			default:		return 15.0
		}
	}
	
}

public let BXTextField_commit = Notification.Name("BXTextField.commit")


//----------------------------------------------------------------------------------------------------------------------


#endif
