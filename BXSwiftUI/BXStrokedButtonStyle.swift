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
	public init() { }

	@Environment(\.colorScheme) var colorScheme

	private func radius(for geometry:GeometryProxy) -> CGFloat
	{
		0.25 * geometry.size.height
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
            .padding(EdgeInsets(top:2, leading:12, bottom:3, trailing:12))
            .background(
				GeometryReader
				{
					geometry in
					
					ZStack
					{
						RoundedRectangle(cornerRadius:self.radius(for:geometry))
							.fill(self.fillColor(for:configuration.isPressed))
						
						RoundedRectangle(cornerRadius:self.radius(for:geometry))
							.stroke(Color.gray,lineWidth:0.5)
					}
				}
			)
    }
}


//----------------------------------------------------------------------------------------------------------------------
