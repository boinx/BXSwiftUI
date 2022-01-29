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
	// Params
	
	public var cornerRadius:CGFloat = 4.0
	public var isEnabled:Bool = true
	
	// Environment
	
//	@Environment(\.isEnabled) var isEnabled:Bool
	@Environment(\.colorScheme) var colorScheme:ColorScheme

	// Init
	
	public init(cornerRadius:CGFloat = 4.0, isEnabled:Bool = true)
	{
		self.cornerRadius = cornerRadius
		self.isEnabled = isEnabled
	}
	
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
			return Color(white:0.65, opacity:isEnabled ? 1.0 : 0.5)
		}
		
		return Color.clear
	}

	// Modify View
	
	public func body(content:Content) -> some View
    {
        content
			.background(
				RoundedRectangle(cornerRadius:self.cornerRadius)
					.inset(by:1.0)
					.fill(fillColor)
			)
			.overlay(
				RoundedRectangle(cornerRadius:self.cornerRadius)
					.inset(by:1.0)
					.stroke(strokeColor, lineWidth:0.5)
			)
    }
}


//----------------------------------------------------------------------------------------------------------------------

