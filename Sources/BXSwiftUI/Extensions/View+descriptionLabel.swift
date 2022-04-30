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
	
	func descriptionLabel(_ description:String, isVisible:Bool = true) -> some View
	{
		VStack(alignment:.leading, spacing:9)
		{
			self

			if isVisible
			{
				Text(description)
					.lineLimit(nil)									// Wrap text to as many lines as needed
					.fixedSize(horizontal:false, vertical:true) 	// Workaround because .lineLimit(nil) doesn't work by itself
					.opacity(0.5)
					#if os(macOS)
					.controlSize(.small)
					#endif
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

