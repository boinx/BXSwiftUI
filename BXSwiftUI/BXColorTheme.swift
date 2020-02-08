//**********************************************************************************************************************
//
//  BXColorTheme.swift
//	Bundles environment values for common UI colors
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXColorTheme
{
	public let fillColor:		(ColorScheme,Bool,Double) -> Color
	public let strokeColor:		(ColorScheme,Bool,Double) -> Color
	public let contentColor:	(ColorScheme,Bool,Double) -> Color
}


//----------------------------------------------------------------------------------------------------------------------


extension BXColorTheme
{
	public static var `default` : BXColorTheme
	{
		BXColorTheme(
			fillColor:			self.defaultFillColor,
			strokeColor:		self.defaultStrokeColor,
			contentColor:		self.defaultContentColor
		)
	}
	
	public static func defaultFillColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
		let gray = colorScheme == .dark ? 1.0 : 0.0
		let alpha = isEnabled ? 0.1*factor : 0.033*factor
		return Color(white:gray, opacity:alpha)
	}

	public static func defaultStrokeColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
		let gray = colorScheme == .dark ? 0.65*factor : 0.35/factor
		let alpha = isEnabled ? 1.0 : 0.33
		return Color(white:gray, opacity:alpha)
	}
	
	public static func defaultContentColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
		let gray = colorScheme == .dark ? 1.0*factor : 1.0-1.0*factor
		let alpha = isEnabled ? 1.0 : 0.33
		return Color(white:gray, opacity:alpha)
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXColorThemeKey : EnvironmentKey
{
	public static let defaultValue:BXColorTheme = BXColorTheme.default
}

public extension EnvironmentValues
{
    var bxColorTheme:BXColorTheme
    {
        set
        {
            self[BXColorThemeKey.self] = newValue
        }

        get
        {
            return self[BXColorThemeKey.self]
        }
    }
}

public extension View
{
	func setBXColorTheme(_ colorTheme:BXColorTheme) -> some View
    {
        self.environment(\.bxColorTheme, colorTheme)
    }
}


//----------------------------------------------------------------------------------------------------------------------


