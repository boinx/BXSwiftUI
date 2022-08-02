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
// Weak() wrapper to break the retain cycle.


public struct BXHostingViewKey : EnvironmentKey
{
	public static let defaultValue:Weak<NativeViewType>? = nil
}


public extension EnvironmentValues
{
    var bxHostingView:NativeViewType?
    {
        set
        {
			if let view = newValue
			{
				let weakWrapper = Weak(view)					// Wrap the view in Weak() to
				self[BXHostingViewKey.self] = weakWrapper		// break the retain cycle
			}
			else
			{
				self[BXHostingViewKey.self] = nil
			}
        }

        get
        {
			let weakWrapper = self[BXHostingViewKey.self]		// Get the Weak() wrapper and
            return weakWrapper?.value							// retrieve the view from it
        }
        
    }
}


//----------------------------------------------------------------------------------------------------------------------

