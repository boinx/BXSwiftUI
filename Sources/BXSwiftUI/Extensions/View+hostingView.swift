//**********************************************************************************************************************
//
//  View+hostingView.swift
//	Environment key for injecting the hostingView (NSView or UIView)
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


// ATTENTION

// Since values injected into the Environment are strongly referenced, injecting the hosting NSView or UIView into a
// SwiftUI view hierarchy creates a retain cycle from a child view back to its ancestor. For this reason we use the
// BXHostingViewProvider to break the retain cycle. This wrapper also solves the chicken-and-egg problem at the call
// site, because the weak reference can be set after creating the NSHostingView.


fileprivate struct BXHostingViewProviderKey : EnvironmentKey
{
	public static let defaultValue = BXHostingViewProvider(nil)
}


public extension EnvironmentValues
{
    var bxHostingViewProvider:BXHostingViewProvider
    {
        set
        {
            self[BXHostingViewProviderKey.self] = newValue
        }

        get
        {
            self[BXHostingViewProviderKey.self]
        }
        
    }
}


public struct BXHostingViewProvider
{
    public weak var view:NativeViewType? = nil
    
    public init(_ view:NativeViewType?)
    {
        self.view = view
    }
}


//----------------------------------------------------------------------------------------------------------------------

