//**********************************************************************************************************************
//
//  View+bxAccessibilityIdentifier.swift
//	Adds accessibility identifiers
//  Copyright ©2025 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


extension View
{
	/// Adds an accessibility identifier if we are running on macOS 11 or newer
	
	public func bxAccessibilityIdentifier(_ identifier:String) -> some View
	{
		if #available(macOS 11,*)
		{
			return self
				.accessibilityIdentifier(identifier)
				.environment(\.bxAccessibilityIdentifier, identifier)
		}
		else
		{
			return self.environment(\.bxAccessibilityIdentifier, identifier)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXGAccessibilityIdentifierKey : EnvironmentKey
{
    static public let defaultValue:String? = nil
}

public extension EnvironmentValues
{
    var bxAccessibilityIdentifier:String?
    {
        set
        {
            self[BXGAccessibilityIdentifierKey.self] = newValue
        }

        get
        {
            return self[BXGAccessibilityIdentifierKey.self]
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------
