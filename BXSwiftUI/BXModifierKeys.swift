//**********************************************************************************************************************
//
//  BXModifierKeys.swift
//	BXModifierKeys detects and publishes modifier key presses
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public final class BXModifierKeys : NSObject, ObservableObject
{
	/// A shared instance that can be injected into the SwiftUI environment
	
	public static var shared = BXModifierKeys()
	
	/// The current set of pressed modifier keys
	
	public var flags:NSEvent.ModifierFlags
	{
		return NSApp.currentEvent?.modifierFlags ?? []
	}
	
	/// Call this function from a flagsChanged() somewhere in your responder chain. The best place would be near the
	/// root (e.g. in the AppDelegate). Make sure to call super so that the responder chain doesn't get broken.
	
    public func flagsChanged(with event:NSEvent)
    {
		self.objectWillChange.send()
    }
}


//----------------------------------------------------------------------------------------------------------------------


