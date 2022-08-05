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
	
	public func bxUndoManager(_ undoManager:UndoManager?) -> some View
	{
		self.environment(\.bxUndoManagerProvider, BXUndoManagerProvider(undoManager))
	}

	/// Injects the undo name into the environment. Controls in the view hierarchy may access it to set an undo name when necessary.
	
	public func bxUndoName(_ name:String) -> some View
	{
        self.environment(\.bxUndoName, name)
	}
}


//----------------------------------------------------------------------------------------------------------------------


// ATTENTION

// Since the UndoManager retains other objects (e.g. ViewControllers that can own a SwiftUI subtree) in its undo and redo
// stacks, we should not strongly reference the UndoManager in the environment - as this can cause retain cycles, and
// thus memory leaks. For this reason we wrap it in a BXUndoManagerProvider (which contains a weak reference)
// to break potential retain cycles. When SwiftUI views need the UndoManager, they need to retrieve at the call site
// from this provider.


fileprivate struct BXUndoManagerProviderKey : EnvironmentKey
{
    static public let defaultValue = BXUndoManagerProvider(nil)
}


public extension EnvironmentValues
{
	/// The UndoManager can be retrieved by a SwiftUI view to record data model property changes
	
    var bxUndoManagerProvider:BXUndoManagerProvider
    {
        set
        {
			self[BXUndoManagerProviderKey.self] = newValue
        }

        get
        {
			self[BXUndoManagerProviderKey.self]
        }
    }
}


public struct BXUndoManagerProvider
{
	public weak var undoManager:UndoManager?
	
	public init(_ undoManager:UndoManager?)
	{
		self.undoManager = undoManager
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

