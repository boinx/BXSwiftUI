//**********************************************************************************************************************
//
//  View+undoManager.swift
//	Custom view extension to support setting undo names
//  Copyright ©2020-2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import Foundation
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


extension View
{
	/// Injects an UndoManager into the environment. Controls in the view hierarchy may access this UndoManager to record value changes.
	
	public func undoManager(_ undoManager:UndoManager?) -> some View
	{
		self.environment(\.bxUndoManager, undoManager)
	}

	/// Injects the undo name into the environment. Controls in the view hierarchy may access it to set an undo name when necessary.
	
	public func undoName(_ name:String) -> some View
	{
        self.environment(\.bxUndoName, name)
	}
}


//----------------------------------------------------------------------------------------------------------------------


// ATTENTION

// Since the UndoManager retains other object (e.g. ViewControllers that can own a SwiftUI subtree) in its undo and redo
// stacks, we should not strongly reference the UndoManager in the environment - as this can cause retain cycles, and
// thus memory leaks. For this reason we use the Weak() wrapper to break potential retain cycles.


public struct BXUndoManagerKey : EnvironmentKey
{
    static public let defaultValue:Weak<UndoManager>? = nil
}


public extension EnvironmentValues
{
	/// The UndoManager can be retrieved by a SwiftUI view to record data model property changes
	
    var bxUndoManager:UndoManager?
    {
        set
        {
			if let undoManager = newValue
			{
				let weakWrapper = Weak(undoManager)				// Wrap the UndoManager in Weak() to
				self[BXUndoManagerKey.self] = weakWrapper		// break a potential retain cycles
			}
			else
			{
				self[BXUndoManagerKey.self] = nil
			}
        }

        get
        {
			let weakWrapper = self[BXUndoManagerKey.self]		// Get the Weak() wrapper and
            return weakWrapper?.value							// retrieve the UndoManager from it
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXUndoNameKey : EnvironmentKey
{
    static public let defaultValue:String = ""
}


public extension EnvironmentValues
{
	/// The undo name for actions
	
    var bxUndoName:String
    {
        set
        {
            self[BXUndoNameKey.self] = newValue
        }

        get
        {
            return self[BXUndoNameKey.self]
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------

