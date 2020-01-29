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
	public init()
	{
	
	}
	
    public func makeBody(configuration:BXStrokedButtonStyle.Configuration) -> some View
    {
        configuration.label
            .padding(EdgeInsets(top:2, leading:12, bottom:3, trailing:12))
            .background(
				GeometryReader
				{
					geometry in
					
					RoundedRectangle(cornerRadius:0.25*geometry.size.height)
						.fill(Color(white:1.0, opacity:configuration.isPressed ? 0.15 : 0.07))
						.overlay(
							RoundedRectangle(cornerRadius:0.25*geometry.size.height)
								.stroke(Color.gray,lineWidth:0.5)
						)
					
				}
			)
    }
}

//----------------------------------------------------------------------------------------------------------------------
