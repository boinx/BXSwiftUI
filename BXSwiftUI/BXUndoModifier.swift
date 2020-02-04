//**********************************************************************************************************************
//
//  BXUndoNameModifier.swift
//	Custom modifier that sets the undo name when a gesture ends
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import Foundation


//----------------------------------------------------------------------------------------------------------------------


public struct BXUndoNameModifier : ViewModifier
{
	// Params
	
	private var undoManager:UndoManager?
	private var name:String
	
	// Init
	
	public init(undoManager:UndoManager? = nil, name:String = "")
	{
		self.undoManager = undoManager
		self.name = name
	}
	
	// Modify View
	
	public func body(content:Content) -> some View
    {
		content.simultaneousGesture(
			
			TapGesture().onEnded()
			{
				self.undoManager?.setActionName(self.name)
			}
		)
    }
}


//----------------------------------------------------------------------------------------------------------------------

