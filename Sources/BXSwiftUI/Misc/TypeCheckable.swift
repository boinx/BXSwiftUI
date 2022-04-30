//**********************************************************************************************************************
//
//  TypeCheckable.swift
//	Runtime checks for generic types
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import Foundation
#if os(iOS)
import CoreGraphics // for CGFloat
#endif


//----------------------------------------------------------------------------------------------------------------------


public protocol TypeCheckable
{
    static var defaultValue:Self { get }
}


extension TypeCheckable
{
    static var isString:Bool
    {
		return Self.defaultValue is String
	}
	
    static var isURL:Bool
    {
		return Self.defaultValue is URL
	}

    static var isDouble:Bool
    {
		return Self.defaultValue is Double
	}

    static var isFloat:Bool
    {
		return Self.defaultValue is Float
	}

    static var isCGFloat:Bool
    {
		return Self.defaultValue is CGFloat
	}

    static var isInt:Bool
    {
		return Self.defaultValue is Int
	}
	
    static var isBool:Bool
    {
		return Self.defaultValue is Bool
	}
}


//----------------------------------------------------------------------------------------------------------------------


extension String : TypeCheckable
{
	public static var defaultValue:Self { "" }
}

extension URL : TypeCheckable
{
	public static var defaultValue:Self { URL(string:"https://www.boinx.com")! }
}

extension Double : TypeCheckable
{
	public static var defaultValue:Self { 0.0 }
}

extension Float : TypeCheckable
{
	public static var defaultValue:Self { 0.0 }
}

extension CGFloat : TypeCheckable
{
	public static var defaultValue:Self { 0.0 }
}

extension Int : TypeCheckable
{
	public static var defaultValue:Self { 0 }
}

extension Bool : TypeCheckable
{
	public static var defaultValue:Self { false }
}


//----------------------------------------------------------------------------------------------------------------------
