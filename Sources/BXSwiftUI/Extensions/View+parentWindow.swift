//**********************************************************************************************************************
//
//  View+parentWindow.swift
//	Injects the owning window into a SwiftUI view hierarchy
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit
import SwiftUI
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	func parentWindow(_ window:NSWindow?) -> some View
	{
		self.environment(\.bxParentWindow,window)
	}
}


//----------------------------------------------------------------------------------------------------------------------


// ATTENTION

// Since values injected into the Environment are strongly referenced, injecting the the parent NSWindow into a
// SwiftUI view hierarchy creates a retain cycle from a child view back to its window. For this reason we use the
// Weak() wrapper to break the retain cycle.


struct BXParentWindowKey : EnvironmentKey
{
    static let defaultValue:Weak<NSWindow>? = nil
}


public extension EnvironmentValues
{
    var bxParentWindow:NSWindow?
    {
        set
        {
			if let window = newValue
			{
				let weakWrapper = Weak(window)					// Wrap the window in Weak()
				self[BXParentWindowKey.self] = weakWrapper		// to break the retain cycle
			}
			else
			{
				self[BXParentWindowKey.self] = nil
			}
        }
        
        get
        {
			let weakWrapper = self[BXParentWindowKey.self]		// Get the Weak() wrapper and
            return weakWrapper?.value							// retrieve the window from it
		}
    }
}

//----------------------------------------------------------------------------------------------------------------------


#endif
