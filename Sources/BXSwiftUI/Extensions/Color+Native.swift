//**********************************************************************************************************************
//
//  Color+Native.swift
//	Converts a SwiftUI Color to a native NSColor
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


@available(macOS, obsoleted:10.16)

public extension NSColor
{
	/// Creates a NSColor from a SwiftUI Color. Please note that macOS 11 Big Sur provides this out of the box

	convenience init(_ color:Color)
	{
        let (r,g,b,a) = Self.components(for:color)
        self.init(srgbRed:r, green:g, blue:b, alpha:a)
	}

	/// Returns a SwiftUI Color for this NSColor
	
	var color:Color
	{
		let r:CGFloat = self.redComponent
		let g:CGFloat = self.greenComponent
		let b:CGFloat = self.blueComponent
        return Color(red:r, green:g, blue:b)
	}
	
	/// Retrieves the (r,g,b,a) components from a SwiftUI color. This is a bit of a hack!
	
    private static func components(for color:Color) -> (CGFloat,CGFloat,CGFloat,CGFloat)
    {
		var description = color.description //.trimmingCharacters(in:CharacterSet.alphanumerics.inverted)
		let parts = description.components(separatedBy:"#")
		if parts.count == 2 { description = parts[1] }
		
        let scanner = Scanner(string:description)
        var hexnum:UInt64 = 0
        var r:CGFloat = 0.0
        var g:CGFloat = 0.0
        var b:CGFloat = 0.0
        var a:CGFloat = 0.0

//     	scanner.scanUpTo("#", into:nil)	// Skip ahead to hex string which starts with '#'
     	
		if scanner.scanHexInt64(&hexnum)
        {
            r = CGFloat((hexnum & 0xff000000) >> 24) / 255
            g = CGFloat((hexnum & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexnum & 0x0000ff00) >> 8)  / 255
            a = CGFloat( hexnum & 0x000000ff)        / 255
        }
        
        return (r,g,b,a)
    }
}


//----------------------------------------------------------------------------------------------------------------------

#endif
