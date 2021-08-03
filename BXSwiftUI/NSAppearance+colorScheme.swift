//**********************************************************************************************************************
//
//  NSAppearance+colorScheme.swift
//	Converts an NSAppearance into a SwiftUI ColorScheme
//  Copyright ©2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public extension NSAppearance
{
    var isDarkMode:Bool
    {
        let darkAppearances:[NSAppearance.Name] =
        [
            .vibrantDark,
            .darkAqua,
            .accessibilityHighContrastVibrantDark,
            .accessibilityHighContrastDarkAqua
        ]
 
        return darkAppearances.contains(self.name)

//         self.name
//            .rawValue
//            .lowercased()
//            .contains("dark")
    }

    var isLightMode:Bool
    {
        !self.isDarkMode
    }
    
	/// Returns the corresponding ColorScheme for this NSAppearance
	
	var colorScheme:ColorScheme
	{
		self.isDarkMode ? .dark : .light
	}
}


//----------------------------------------------------------------------------------------------------------------------


