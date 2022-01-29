//**********************************************************************************************************************
//
//  View+fixedSize.swift
//	Wraps a view in a fixed size container
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Wraps a view in a fixed size container
	/// - parameter width: The width of the container
	/// - parameter height: The height of the container
	/// - parameter alignment: The alignment within the container
	
	func fixedSize(width:CGFloat, height:CGFloat, alignment:Alignment = .center) -> some View
	{
		Spacer()
			.frame(width:width, height:height)
			.overlay(self, alignment:alignment)
	}
	
}


//----------------------------------------------------------------------------------------------------------------------
