//**********************************************************************************************************************
//
//  BXGradientFillStyle.swift
//	Environment fill style for some custom controls
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXGradientFillStyleKey : EnvironmentKey
{
    static public let defaultValue:LinearGradient? = nil
}

public extension EnvironmentValues
{
    var bxGradientFillStyle:LinearGradient?
    {
        set
        {
            self[BXGradientFillStyleKey.self] = newValue
        }

        get
        {
            return self[BXGradientFillStyleKey.self]
        }
    }
}

public extension View
{
	func bxGradientFillStyle(_ gradient:LinearGradient) -> some View
    {
        self.environment(\.bxGradientFillStyle, gradient)
    }
}


//----------------------------------------------------------------------------------------------------------------------
