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
	let backgroundColor: (ColorScheme)->Color
	let fillColor: (ColorScheme,Bool,Double)->Color
	let strokeColor: (ColorScheme,Bool,Double)->Color
	let contentColor: (ColorScheme,Bool,Double)->Color
	
	public init(backgroundColor:@escaping (ColorScheme)->Color, fillColor:@escaping (ColorScheme,Bool,Double)->Color, strokeColor:@escaping (ColorScheme,Bool,Double)->Color, contentColor:@escaping (ColorScheme,Bool,Double)->Color)
	{
		self.backgroundColor = backgroundColor
		self.fillColor = fillColor
		self.strokeColor = strokeColor
		self.contentColor = contentColor
	}
}


//----------------------------------------------------------------------------------------------------------------------


extension BXColorTheme
{
	public func backgroundColor(for colorScheme:ColorScheme = .dark) -> Color
	{
		return self.backgroundColor(colorScheme)
	}
	
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
			backgroundColor:	self.defaultBackgroundColor,
			fillColor:			self.defaultFillColor,
			strokeColor:		self.defaultStrokeColor,
			contentColor:		self.defaultContentColor
		)
	}
	
	internal static func defaultBackgroundColor(for colorScheme:ColorScheme) -> Color
	{
		let gray = colorScheme == .dark ? 0.19 : 0.85
		return Color(white:gray, opacity:1.0)
	}

	internal static func defaultFillColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
//		let gray = colorScheme == .dark ? 1.0 : 0.0
//		let alpha = isEnabled ? 0.1*factor : 0.033*factor
//		return Color(white:gray, opacity:alpha)

		var alpha = isEnabled ? 0.1*factor : 0.033*factor
		
		if colorScheme == .light
		{
			alpha = isEnabled ? 1.0 : 0.33
		}
		
		return Color(white:1.0, opacity:alpha)
	}

	internal static func defaultStrokeColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
		let gray = colorScheme == .dark ? 0.65*factor : 0.6/factor
		let alpha = isEnabled ? 1.0 : 0.33
		return Color(white:gray, opacity:alpha)
	}
	
	internal static func defaultContentColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
		let gray = colorScheme == .dark ? 1.0*factor : 0.1/factor
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


