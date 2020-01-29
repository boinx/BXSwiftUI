//**********************************************************************************************************************
//
//  BXCircularSlider.swift
//	A circular slider for SwiftUI
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXStrokedCheckboxStyle : ToggleStyle
{
    let width: CGFloat = 15
    
    public init() {}
    
    public func makeBody(configuration: Self.Configuration) -> some View
    {
        HStack
        {
            ZStack()
            {
                RoundedRectangle(cornerRadius:3)
                    .foregroundColor(configuration.isOn ? Color.accentColor : Color(white:1.0, opacity:0.07))
                    .frame(width:width, height:width)

				RoundedRectangle(cornerRadius:3)
                    .stroke(Color.gray, lineWidth:0.5)
					.frame(width:width, height:width)
					
				if configuration.$isOn.wrappedValue
				{
					Text("✓").bold().offset(x:0.5, y:0)
				}
            }
			
			configuration.label
        }
		.onTapGesture
		{
			configuration.$isOn.wrappedValue.toggle()
		}
    }
}


//----------------------------------------------------------------------------------------------------------------------
