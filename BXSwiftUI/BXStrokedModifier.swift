//**********************************************************************************************************************
//
//  BXStrokedModifier.swift
//	Custom modifier that is needed by FotoMagico to prettify dark mode popup menus
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXStrokedModifier : ViewModifier
{
	// Environment
	
	@Environment(\.isEnabled) var isEnabled
	@Environment(\.colorScheme) var colorScheme

	// Init
	
	public init() {}
	
	// Appearance
	
	private var fillColor : Color
	{
		if colorScheme == .dark
		{
			return Color(white:0.0, opacity:isEnabled ? 1.0 : 0.5)
		}
		
		return Color.clear
	}

	private var strokeColor : Color
	{
		if colorScheme == .dark
		{
			return Color(white:0.65, opacity:isEnabled ? 1.0 : 0.33)
		}
		
		return Color.clear
	}

	// Modify View
	
	public func body(content:Content) -> some View
    {
        content
			.background(
				RoundedRectangle(cornerRadius:4.0)
					.inset(by:1.0)
					.fill(fillColor)
			)
			.overlay(
				RoundedRectangle(cornerRadius:4.0)
					.inset(by:1.0)
					.stroke(strokeColor, lineWidth:0.5)
			)
    }
}


//----------------------------------------------------------------------------------------------------------------------

