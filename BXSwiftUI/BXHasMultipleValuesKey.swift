//**********************************************************************************************************************
//
//  BXHasMultipleValuesKey.swift
//	Custom environment key for multiple values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXHasMultipleValuesKey : EnvironmentKey
{
    static public let defaultValue:Bool = false
}

public extension EnvironmentValues
{
    var hasMultipleValues:Bool
    {
        set
        {
            self[BXHasMultipleValuesKey.self] = newValue
        }

        get
        {
            return self[BXHasMultipleValuesKey.self]
        }
    }
}

public extension View
{
	func hasMultipleValues(_ hasMultipleValues:Bool) -> some View
    {
        self.environment(\.hasMultipleValues, hasMultipleValues)
    }
}


//----------------------------------------------------------------------------------------------------------------------
