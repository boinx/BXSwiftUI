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
	// Injects the document into the environment. Controls in the view hierarchy may access it access its UndoManager.
	
	public func setDocument(_ document:NSDocument?) -> some View
	{
		self.environment(\.document, document)
	}

	// Injects the undo name into the environment. Controls in the view hierarchy may access it to set an undo name when necessary.
	
	public func setUndoName(_ name:String) -> some View
	{
        self.environment(\.undoName, name)
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXDocumentKey : EnvironmentKey
{
    static public let defaultValue:NSDocument? = nil
}

public extension EnvironmentValues
{
	/// The document that provides access to the UndoManager
	
    var document:NSDocument?
    {
        set
        {
            self[BXDocumentKey.self] = newValue
        }

        get
        {
            return self[BXDocumentKey.self]
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
	
    var undoName:String
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

