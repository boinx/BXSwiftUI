import Foundation


//----------------------------------------------------------------------------------------------------------------------


public protocol TypeCheckable
{
    static var defaultValue:Self { get }
}


extension TypeCheckable
{
    static var isString:Bool
    {
		let type = Self.defaultValue
		return type is String
	}

    static var isDouble:Bool
    {
		let type = Self.defaultValue
		return type is Double
	}

    static var isInt:Bool
    {
		let type = Self.defaultValue
		return type is Int
	}
	
    static var isBool:Bool
    {
		let type = Self.defaultValue
		return type is Bool
	}
}


//----------------------------------------------------------------------------------------------------------------------


extension String : TypeCheckable
{
	public static var defaultValue:Self { "" }
}

extension Double : TypeCheckable
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
