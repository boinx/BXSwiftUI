//**********************************************************************************************************************
//
//  BXModifierKeys.swift
//	BXModifierKeys detects and publishes modifier key presses
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public final class BXModifierKeys : NSObject, ObservableObject
{
	/// A shared instance that can be injected into the SwiftUI environment
	
	public static var shared = BXModifierKeys()
	
	/// The currently pressed key
	
	@Published public var key:String? = nil
	

//----------------------------------------------------------------------------------------------------------------------


	/// Key event handlers of this type  can be registered with BXModifierKeys
	
	public typealias Handler = (NSEvent)->Void
	
	/// The registered keyDown handlers
	
	public var onKeyDown:[String:Handler] = [:]
	
	/// The registered keyUp handlers
	
	public var onKeyUp:[String:Handler] = [:]
	
	/// The registered flagsChanged handlers
	
	public var onFlagsChanged:[String:Handler] = [:]
	
	
//----------------------------------------------------------------------------------------------------------------------


	/// Call this function from a flagsChanged() somewhere in your responder chain. The best place would be near the
	/// root (e.g. in the AppDelegate). Make sure to call super so that the responder chain doesn't get broken.
	
    public func flagsChanged(with event:NSEvent)
    {
		self.objectWillChange.send()

		self.lastKnownFlags = event.modifierFlags	// Remember current modifiers for later use
		
		for (_,handler) in onFlagsChanged
		{
			handler(event)
		}
    }


	/// Call this function from a keyDown() somewhere in your responder chain. The best place would be near the
	/// root (e.g. in the AppDelegate). Make sure to call super so that the responder chain doesn't get broken.
	
    public func keyDown(with event:NSEvent)
    {
		self.key = event.charactersIgnoringModifiers
		
		for (_,handler) in onKeyDown
		{
			handler(event)
		}
    }
    
	/// Call this function from a keyUp() somewhere in your responder chain. The best place would be near the
	/// root (e.g. in the AppDelegate). Make sure to call super so that the responder chain doesn't get broken.
	
    public func keyUp(with event:NSEvent)
    {
		for (_,handler) in onKeyUp
		{
			handler(event)
		}

		self.key = nil
    }
    
	/// Returns the current state of the modifier keys, using Apple's static API, which seems to be unreliable in certain scenarios
	
 	public var currentFlags:NSEvent.ModifierFlags
 	{
		NSEvent.modifierFlags
 	}
 	
	/// Returns the last know state of the modifier keys. This is useful when the currentFlags is unreliable
	
 	public var lastKnownFlags:NSEvent.ModifierFlags = []
}


//----------------------------------------------------------------------------------------------------------------------


#endif
