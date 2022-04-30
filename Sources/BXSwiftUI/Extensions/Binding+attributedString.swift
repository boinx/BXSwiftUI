//**********************************************************************************************************************
//
//  Binding+attributedString.swift
//	Converts a String Binding to a NSAttributedString Binding
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension Binding
{
	/// Creates a Binding to an NSAttributedString from a regular String Binding

	static func attributedString(for binding:Binding<String>, font:NSFont? = NSFont.systemFont(ofSize:13), color:NSColor? = nil) -> Binding<NSAttributedString>
	{
		return Binding<NSAttributedString>(
		
			get:
			{
				var attrs:[NSAttributedString.Key:Any] = [:]
				if let font = font { attrs[NSAttributedString.Key.font] = font }
				if let color = color { attrs[NSAttributedString.Key.foregroundColor] = color }
				return NSAttributedString(string:binding.wrappedValue, attributes:attrs)
			},
			
			set:
			{
				binding.wrappedValue = $0.string
			})
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
