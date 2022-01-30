//**********************************************************************************************************************
//
//  BXSliderStyle.swift
//	A circular slider for SwiftUI
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public enum BXSliderStyle
{
	/// Uses BXMultiValueNativeSlider
	
	case native
	
	/// Uses BXMultiValueColorSlider
	
	case color(_ color:Color)

	/// Uses BXMultiValueGradientSlider
		
	case gradient(_ gradient:Gradient)
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXSliderStyleKey : EnvironmentKey
{
    static public let defaultValue = BXSliderStyle.native
}


public extension EnvironmentValues
{
    var bxSliderStyle : BXSliderStyle
    {
        set
        {
            self[BXSliderStyleKey.self] = newValue
        }

        get
        {
            return self[BXSliderStyleKey.self]
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	func bxSliderStyle(_ style:BXSliderStyle) -> some View
    {
        return self.environment(\.bxSliderStyle, style)
    }
}


//----------------------------------------------------------------------------------------------------------------------
