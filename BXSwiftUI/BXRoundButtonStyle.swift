//**********************************************************************************************************************
//
//  BXStrokedButtonStyle.swift
//	A custom style for Button
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXRoundButtonStyle : ButtonStyle
{
	public init() {}

	// Unfortunately @Environment values cannot be accessed directly from a ButtonStyle, so
	// we will create a private subview, which does have access to the @Environment values.
	
    public func makeBody(configuration:BXRoundButtonStyle.Configuration) -> some View
    {
		_BXRoundButton(configuration:configuration)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// Internal view type that does the actual rendering on behalf of the BXStrokedButtonStyle.
// Since it is a View, it does have access to @Environment values!

fileprivate struct _BXRoundButton : View
{
	// Params
	
	let configuration:ButtonStyleConfiguration

	// Environment
	
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.bxColorTheme) var bxColorTheme

	// State
	
	@State private var isPressed = false
	
	private var fillColor : Color
	{
		return bxColorTheme.fillColor(for:colorScheme, enhanceBy:isPressed ? 1.5 : 1.0)
	}

	private var strokeColor : Color
	{
		return bxColorTheme.strokeColor(for:colorScheme)
	}

	// Build View
	
    var body: some View
    {
		ZStack
		{
			Circle()
				.fill(self.fillColor)
				
			Circle()
				.stroke(self.strokeColor, lineWidth:0.5)
				
			self.configuration.label
				
		}
		
		.simultaneousGesture( LongPressGesture(minimumDuration:0.0)
		
			.onChanged
			{
				_ in
				self.isPressed = true
			}
			
			.onEnded
			{
				_ in
				self.isPressed = false
			}
		)
		
		.reducedOpacityWhenDisabled()
    }
}


//----------------------------------------------------------------------------------------------------------------------
