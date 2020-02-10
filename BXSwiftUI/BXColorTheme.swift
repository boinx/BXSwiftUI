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
	internal let fillColor:		(ColorScheme,Bool,Double) -> Color
	internal let strokeColor:	(ColorScheme,Bool,Double) -> Color
	internal let contentColor:	(ColorScheme,Bool,Double) -> Color
}


//----------------------------------------------------------------------------------------------------------------------


extension BXColorTheme
{
	public func fillColor(for colorScheme:ColorScheme = .dark, isEnabled:Bool = true, enhanceBy factor:Double = 1.0) -> Color
	{
		return self.fillColor(colorScheme,isEnabled,factor)
	}
	
	public func strokeColor(for colorScheme:ColorScheme = .dark, isEnabled:Bool = true, enhanceBy factor:Double = 1.0) -> Color
	{
		return self.strokeColor(colorScheme,isEnabled,factor)
	}
	
	public func contentColor(for colorScheme:ColorScheme = .dark, isEnabled:Bool = true, enhanceBy factor:Double = 1.0) -> Color
	{
		return self.contentColor(colorScheme,isEnabled,factor)
	}
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
	
	internal static func defaultFillColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
		let gray = colorScheme == .dark ? 1.0 : 0.0
		let alpha = isEnabled ? 0.1*factor : 0.033*factor
		return Color(white:gray, opacity:alpha)
	}

	internal static func defaultStrokeColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
		let gray = colorScheme == .dark ? 0.65*factor : 0.35/factor
		let alpha = isEnabled ? 1.0 : 0.33
		return Color(white:gray, opacity:alpha)
	}
	
	internal static func defaultContentColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
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


