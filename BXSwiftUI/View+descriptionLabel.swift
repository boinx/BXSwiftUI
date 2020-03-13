//**********************************************************************************************************************
//
//  View+descriptionLabel.swift
//	Adds a descriptive label below a View
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Adds a descriptive label below a View. This label will be dimmed, so that the original View appears
	/// to be more dominant (important).
	
	func descriptionLabel(_ description:String) -> some View
	{
		VStack(alignment:.leading)
		{
			self

			Text(description)
				.controlSize(.small)
				.lineLimit(nil)									// Wrap text to as many lines as needed
				.fixedSize(horizontal:false, vertical:true) 	// Workaround because .lineLimit(nil) doesn't work by itself
				.opacity(0.33)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

