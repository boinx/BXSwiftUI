//**********************************************************************************************************************
//
//  View+parentWindow.swift
//	Environment key forinjecting a parent window into the view hierarchy
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI

#if canImport(AppKit)
import AppKit
public typealias WindowType = NSWindow
#endif

#if canImport(UIKit)
import UIKit
public typealias WindowType = UIWindow
#endif


//----------------------------------------------------------------------------------------------------------------------


public struct ParentWindowKey : EnvironmentKey
{
//	#if canImport(UIKit)
//    public typealias WrappedValue = UIWindow
//	#elseif canImport(AppKit)
//    public typealias WrappedValue = NSWindow
//	#endif
//
//	public typealias Value = () -> WrappedValue? // needed for weak link
//
//	public static let defaultValue: Self.Value = { nil }

	public typealias Value = WindowType?
	
	public static let defaultValue:Value = nil
}


//----------------------------------------------------------------------------------------------------------------------


public extension EnvironmentValues
{
    var parentWindow:WindowType?
    {
        get
        {
            return self[ParentWindowKey.self]
        }
        
        set
        {
            self[ParentWindowKey.self] = newValue
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------

