//**********************************************************************************************************************
//
//  View+description.swift
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
	
	func description(_ description:String) -> some View
	{
		VStack(alignment:.leading)
		{
			self

			Text(description)
				.lineLimit(nil)
				.controlSize(.small)
				.opacity(0.33)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

