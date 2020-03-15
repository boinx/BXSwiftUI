//**********************************************************************************************************************
//
//  Binding+attributedString.swift
//	Converts a String Binding to a NSAttributedString Binding
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension Binding
{
	/// Creates a Binding to an NSAttributedString from a regular String Binding

	static func attributedString(for binding:Binding<String>) -> Binding<NSAttributedString>
	{
		return Binding<NSAttributedString>(
		
			get:
			{
				NSAttributedString(string:binding.wrappedValue)
			},
			
			set:
			{
				binding.wrappedValue = $0.string
			})
	}
}


//----------------------------------------------------------------------------------------------------------------------

