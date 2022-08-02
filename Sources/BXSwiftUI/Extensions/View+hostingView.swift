//**********************************************************************************************************************
//
//  View+hostingView.swift
//	Environment key for injecting the hostingView (NSView or UIView
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import BXSwiftUtils

#if canImport(AppKit)
import AppKit
public typealias NativeViewType = NSView
#endif

#if canImport(UIKit)
import UIKit
public typealias NativeViewType = UIView
#endif


//----------------------------------------------------------------------------------------------------------------------


public struct HostingViewKey : EnvironmentKey
{
	public typealias Value = Weak<NativeViewType>?
	
	public static let defaultValue:Value = nil
}


//----------------------------------------------------------------------------------------------------------------------


public extension EnvironmentValues
{
    var hostingView:Weak<NativeViewType>?
    {
        get
        {
            return self[HostingViewKey.self]
        }
        
        set
        {
            self[HostingViewKey.self] = newValue
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------

