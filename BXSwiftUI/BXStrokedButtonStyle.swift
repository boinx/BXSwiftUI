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
	private let isHilited:Bool
	
	public init(isHilited:Bool = false)
	{
		self.isHilited = isHilited
	}

	// Unfortunately @Environment values cannot be accessed directly from a ButtonStyle, so
	// we will create a private subview, which does have access to the @Environment values.
	
    public func makeBody(configuration:BXStrokedButtonStyle.Configuration) -> some View
    {
		_BXStrokedButton(configuration:configuration, isHilited:isHilited)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// Internal view type that does the actual rendering on behalf of the BXStrokedButtonStyle.
// Since it is a View, it does have access to @Environment values!

fileprivate struct _BXStrokedButton : View
{
	// Params
	
	let configuration:ButtonStyleConfiguration
	let isHilited:Bool

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
			
			default: return EdgeInsets(top:2, leading:12, bottom:3, trailing:12)
		}
	}
	
	private var fillColor : Color
	{
		if configuration.isPressed || isHilited
		{
			return bxColorTheme.hiliteColor(for:colorScheme)
		}
		
		return colorScheme == .dark ? bxColorTheme.fillColor(for:colorScheme) : .white
	}

	private var textColor : Color
	{
		configuration.isPressed || isHilited ? .white : .primary
	}
	
	private var strokeColor : Color
	{
		colorScheme == .dark ?
			self.bxColorTheme.strokeColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:1) :
			self.bxColorTheme.strokeColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:0.5)
	}

	// Build the view
	
    var body: some View
    {
		self.configuration.label
			.foregroundColor(self.textColor)
            .padding(padding)
			.reducedOpacityWhenDisabled()

            .background(
            
				GeometryReader
				{
					geometry in

					ZStack
					{
						RoundedRectangle(cornerRadius:self.radius(for:geometry))
							.fill(self.fillColor)

						RoundedRectangle(cornerRadius:self.radius(for:geometry))
							.stroke(self.strokeColor, lineWidth:1.0)
					}
					.cornerRadius(self.radius(for:geometry))
					.clipped()
					.reducedOpacityWhenDisabled()
				}
			)
    }
}


//----------------------------------------------------------------------------------------------------------------------
