//**********************************************************************************************************************
//
//  View+Undo.swift
//	Custom view extension to support setting undo names
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import Foundation


//----------------------------------------------------------------------------------------------------------------------


extension View
{
	/// Injects the document into the environment. Controls in the view hierarchy may access it access its UndoManager.
	
	public func setUndoManager(_ undoManager:UndoManager?) -> some View
	{
		self.environment(\.bxUndoManager, undoManager)
	}

	/// Injects the undo name into the environment. Controls in the view hierarchy may access it to set an undo name when necessary.
	
	public func setUndoName(_ name:String) -> some View
	{
        self.environment(\.bxUndoName, name)
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXUndoManagerKey : EnvironmentKey
{
    static public let defaultValue:UndoManager? = nil
}

public extension EnvironmentValues
{
	/// The document that provides access to the UndoManager
	
    var bxUndoManager:UndoManager?
    {
        set
        {
            self[BXUndoManagerKey.self] = newValue
        }

        get
        {
            return self[BXUndoManagerKey.self]
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

