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
	// The control size is provided by the environment. needs to be converted to NSControl datatype
	
	@Environment(\.controlSize) private var controlSize:ControlSize
	
	// Necessary to make init available outside this module
	
	public init() {}
    
    // Edge length and corner radius of the checkbox depend on environment controlSize
    
	private var edge:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 15.0
			case .small: 		return 12.0
			case .mini: 		return 9.0
			@unknown default:	return 15.0
		}
	}

	private var radius:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 3.0
			case .small: 		return 2.0
			case .mini: 		return 2.0
			@unknown default:	return 3.0
		}
	}

	// Draw the checkbox
	
    public func makeBody(configuration: Self.Configuration) -> some View
    {
        HStack
        {
            ZStack()
            {
                RoundedRectangle(cornerRadius:radius)
                    .foregroundColor(configuration.isOn ? Color.accentColor : Color(white:1.0, opacity:0.07))
                    .frame(width:edge, height:edge)

				RoundedRectangle(cornerRadius:radius)
                    .stroke(Color.gray, lineWidth:0.5)
					.frame(width:edge, height:edge)
					
				if configuration.isOn
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
