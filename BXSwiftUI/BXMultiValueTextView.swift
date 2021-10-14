//**********************************************************************************************************************
//
//  BXMultiValueTextView.swift
//	SwiftUI wrapper for a NSTextfield that supports multiple values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


struct BXMultiValueTextView : View
{
	// Params
	
    private var values:Binding<Set<NSAttributedString>>
	private var statusHandler:(BXTextViewStatusHandler)? = nil
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.colorScheme) private var colorScheme

	// Custom bindings
	
	private var textBinding:Binding<NSAttributedString>
	{
		 Binding<NSAttributedString>(
		 
			get:
			{
				if self.values.wrappedValue.count > 1
				{
					return NSAttributedString(string:"Multiple", attributes:[.foregroundColor:textColor])
				}
				else if let value = self.values.wrappedValue.first
				{
					return value
				}
				
				return NSAttributedString(string:"None", attributes:[.foregroundColor:textColor])
			},
			
			set:
			{
				self.values.wrappedValue = Set([$0])
			})
	}
	
	private var textColor:NSColor
	{
		colorScheme == .dark ? NSColor(calibratedWhite:1.0, alpha:0.35) : NSColor(calibratedWhite:0.0, alpha:0.35)
	}
	
	// Init
	
	public init(values:Binding<Set<NSAttributedString>>, statusHandler:(BXTextViewStatusHandler)? = nil)
	{
		self.values = values
		self.statusHandler = statusHandler
	}

	// Build the view
	
	public var body: some View
	{
		BXTextView(value:textBinding, statusHandler:statusHandler)
	}
}


//----------------------------------------------------------------------------------------------------------------------
