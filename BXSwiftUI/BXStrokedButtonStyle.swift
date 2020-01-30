//**********************************************************************************************************************
//
//  BXStrokedButtonStyle.swift
//	A custom style for Button
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXStrokedButtonStyle: ButtonStyle
{
	private var enabled:Bool
	
	@Environment(\.colorScheme) var colorScheme

	public init(_ enabled:Bool = true)
	{
		self.enabled = enabled
	}

	private func radius(for geometry:GeometryProxy) -> CGFloat
	{
		0.25 * geometry.size.height
	}
	
	private var insets : EdgeInsets
	{
		let spacing:CGFloat = enabled ? 12.0 : 0.0
		return EdgeInsets(top:2, leading:spacing, bottom:3, trailing:spacing)
	}
	
	private func fillColor(for isPressed:Bool) -> Color
	{
		let gray = colorScheme == .dark ? 1.0 : 1.0
		let alpha = isPressed ? 0.15 : 0.07
		return Color(white:gray, opacity:alpha)
	}

    public func makeBody(configuration:BXStrokedButtonStyle.Configuration) -> some View
    {
		configuration.label
            .padding(self.insets)
            .background(
				GeometryReader
				{
					geometry in
					
					if self.enabled
					{
						ZStack
						{
							RoundedRectangle(cornerRadius:self.radius(for:geometry))
								.fill(self.fillColor(for:configuration.isPressed))
							
							RoundedRectangle(cornerRadius:self.radius(for:geometry))
								.stroke(Color.gray,lineWidth:0.5)
						}
					}
				}
			)
    }
}


//----------------------------------------------------------------------------------------------------------------------
