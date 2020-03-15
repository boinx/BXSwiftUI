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
	@Environment(\.controlSize) var controlSize
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.bxColorTheme) var bxColorTheme

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
		if colorScheme == .light { return configuration.isPressed ? .accentColor : .white }
		let factor = configuration.isPressed ? 2.0 : 1.0
		return bxColorTheme.fillColor(for:colorScheme, enhanceBy:factor)
	}

	private var strokeColor : Color
	{
		return bxColorTheme.strokeColor(for:colorScheme)
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
					.reducedOpacityWhenDisabled()
				}
			)
    }
}


//----------------------------------------------------------------------------------------------------------------------
