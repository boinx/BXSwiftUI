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
	let hiliteColor: (ColorScheme,Bool,Double)->Color
	
	public init(backgroundColor:@escaping (ColorScheme)->Color, fillColor:@escaping (ColorScheme,Bool,Double)->Color, strokeColor:@escaping (ColorScheme,Bool,Double)->Color, contentColor:@escaping (ColorScheme,Bool,Double)->Color, hiliteColor:@escaping (ColorScheme,Bool,Double)->Color)
	{
		self.backgroundColor = backgroundColor
		self.fillColor = fillColor
		self.strokeColor = strokeColor
		self.contentColor = contentColor
		self.hiliteColor = hiliteColor
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
	
	public func hiliteColor(for colorScheme:ColorScheme = .dark, isEnabled:Bool = true, enhanceBy factor:Double = 1.0) -> Color
	{
		return self.hiliteColor(colorScheme,isEnabled,factor)
	}
}


//----------------------------------------------------------------------------------------------------------------------


/// BUGFIX: Please note that we are using the grayscale value 0.99 instead of 1.0 in several cases here, because of a bug on macOS 11 Big Sur which fails
/// to correctly convert a SwiftUI Color to NSColor when using 1.0 values. Using "almost" white is a workaround for the problem.

extension BXColorTheme
{
	public static var `default` : BXColorTheme
	{
		BXColorTheme(
			backgroundColor:	self.defaultBackgroundColor,
			fillColor:			self.defaultFillColor,
			strokeColor:		self.defaultStrokeColor,
			contentColor:		self.defaultContentColor,
			hiliteColor:		self.defaultHiliteColor
		)
	}
	
	public static func defaultBackgroundColor(for colorScheme:ColorScheme) -> Color
	{
		let gray = colorScheme == .dark ? 0.19 : 0.85
		return Color(white:gray, opacity:1.0)
	}

	public static func defaultFillColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
		var alpha = isEnabled ? 0.075*factor : 0.025*factor
		
		if colorScheme == .light
		{
            alpha = isEnabled ? 1.0 : 0.33
		}
		
        return Color(white:0.999, opacity:alpha)
	}

	public static func defaultStrokeColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
        var gray = 0.999
		var alpha = isEnabled ? 0.39 : 0.13

		if colorScheme == .light
		{
			gray = 0.0
			alpha = isEnabled ? 0.3 : 0.1
		}

		return Color(white:gray, opacity:alpha*factor)
	}
	
	public static func defaultContentColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
		let gray = colorScheme == .dark ? 0.999 : 0.1
        let alpha = isEnabled ? 1.0 : 0.33
		return Color(white:gray, opacity:alpha*factor)
	}
	
	public static func defaultHiliteColor(for colorScheme:ColorScheme, isEnabled:Bool, enhanceBy factor:Double = 1.0) -> Color
	{
		let alpha = isEnabled ? 1.0 : 0.33
		return Color.accentColor.opacity(alpha)
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
	func bxColorTheme(_ colorTheme:BXColorTheme) -> some View
    {
        self.environment(\.bxColorTheme, colorTheme)
    }
}


//----------------------------------------------------------------------------------------------------------------------


