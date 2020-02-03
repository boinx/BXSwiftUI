//**********************************************************************************************************************
//
//  BXStrokedButtonStyle.swift
//	A custom style for Button
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXStrokedButtonStyle : ButtonStyle
{
	public init() {}

	// Unfortunately @Environment values cannot be accessed directly from a ButtonStyle, so
	// we will create a private subview, which does have access to the @Environment values.
	
    public func makeBody(configuration:BXStrokedButtonStyle.Configuration) -> some View
    {
		_BXStrokedButton(configuration:configuration)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// Internal view type that does the actual rendering on behalf of the BXStrokedButtonStyle.
// Since it is a View, it does have access to @Environment values!

fileprivate struct _BXStrokedButton : View
{
	// Params
	
	let configuration:ButtonStyleConfiguration

	// Environment
	
	@Environment(\.isEnabled) var isEnabled
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.controlSize) var controlSize

	// Exact appearance depends on environment values
	
	private func radius(for geometry:GeometryProxy) -> CGFloat
	{
		0.25 * geometry.size.height
	}
	
	private var padding : EdgeInsets
	{
		switch controlSize
		{
			case .regular: 	return EdgeInsets(top:2, leading:12, bottom:3, trailing:12)
			case .small: 	return EdgeInsets(top:1, leading:12, bottom:1, trailing:12)
			case .mini: 	return EdgeInsets(top:1, leading:12, bottom:1, trailing:12)
			
			@unknown default: return EdgeInsets(top:2, leading:12, bottom:3, trailing:12)
		}
	}
	
	private var fillColor : Color
	{
		let gray = self.colorScheme == .dark ? 1.0 : 0.0
		var alpha = self.configuration.isPressed ? 0.15 : 0.07
		if !isEnabled { alpha *= 0.33 }
		return Color(white:gray, opacity:alpha)
	}

	private var strokeColor : Color
	{
		let gray = self.colorScheme == .dark ? 0.65 : 0.35
		let alpha = self.isEnabled ? 1.0 : 0.33
		return Color(white:gray, opacity:alpha)
	}

	// Build the view
	
    var body: some View
    {
		self.configuration.label
            .padding(padding)
            .background(
            
				GeometryReader
				{
					geometry in

					ZStack
					{
						RoundedRectangle(cornerRadius:self.radius(for:geometry))
							.fill(self.fillColor)

						RoundedRectangle(cornerRadius:self.radius(for:geometry))
							.stroke(self.strokeColor, lineWidth:0.5)
					}
				}
			)
    }
}


//----------------------------------------------------------------------------------------------------------------------
