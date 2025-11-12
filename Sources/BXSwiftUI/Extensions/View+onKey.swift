//**********************************************************************************************************************
//
//  View+onKey.swift
//	Adds key press support to a SwiftUI view
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public struct BXKeyEventView : NSViewRepresentable
{
	/// Handler closures
	
	var isFocused:((Bool)->Void)? = nil
	var onKeyDown:(NSEvent)->Void
	var onKeyUp:(NSEvent)->Void
	var onModifiersChanged:(NSEvent)->Void
	
	/// AppKit helper view that performs keyboard handling
	
    public class KeyView : NSView
    {
		var isFocused:((Bool)->Void)? = nil
		var onKeyDown:(NSEvent)->Void = { _ in }
		var onKeyUp:(NSEvent)->Void = { _ in }
		var onModifiersChanged:(NSEvent)->Void = { _ in }

		// Set this helper view as initialFirstResponder, so that we can restore it when textfields resign
		
		override public func viewDidMoveToWindow()
		{
			guard let window = self.window else { return }
			window.initialFirstResponder = self
            window.makeFirstResponder(self)
            window.makeKey()
		}
		
        override public var acceptsFirstResponder:Bool
        {
			true
        }
        
        public override func becomeFirstResponder() -> Bool
		{
			self.isFocused?(true)
			return true
		}
		
        public override func resignFirstResponder() -> Bool
        {
			self.isFocused?(false)
			return true
        }
        
		
        // Keyboard event handling
        
        override public func keyDown(with event:NSEvent)
        {
            self.onKeyDown(event)
        }
        
        override public func keyUp(with event:NSEvent)
        {
        	self.onKeyUp(event)
        }
        
		override public func flagsChanged(with event:NSEvent)
		{
			self.onModifiersChanged(event)
		}
    }


	// Create helper view
		
	public func makeNSView(context:Context) -> KeyView
    {
        let view = KeyView(frame:.zero)
		view.isFocused = self.isFocused
        view.onKeyDown = self.onKeyDown
        view.onKeyUp = self.onKeyUp
        return view
    }

	public func updateNSView(_ keyView:KeyView, context:Context)
    {
    
    }
}


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Adds a keyDown handler to a view
	
	func onKeyDown(isFocused:((Bool)->Void)? = nil, action:@escaping (NSEvent)->Void) -> some View
	{
		return self.background(
			BXKeyEventView(isFocused:isFocused, onKeyDown:action, onKeyUp:{ _ in }, onModifiersChanged:{ _ in })
		)
	}

	/// Adds a keyUp handler to a view
	
	func onKeyUp(isFocused:((Bool)->Void)? = nil, action:@escaping (NSEvent)->Void) -> some View
	{
		return self.background(
			BXKeyEventView(isFocused:isFocused, onKeyDown:{ _ in }, onKeyUp:action, onModifiersChanged:{ _ in })
		)
	}
	
	/// Adds a keyUp handler to a view
	
	func onModifiersChanged(isFocused:((Bool)->Void)? = nil, action:@escaping (NSEvent)->Void) -> some View
	{
		return self.background(
			BXKeyEventView(isFocused:isFocused, onKeyDown:{ _ in }, onKeyUp:{ _ in }, onModifiersChanged:action)
		)
	}
	
	/// Adds a keyDown/Up handlers to a view
	
	func onKey(isFocused:((Bool)->Void)? = nil, down:@escaping (NSEvent)->Void = { _ in }, up:@escaping (NSEvent)->Void = { _ in }, modifiers:@escaping (NSEvent)->Void = { _ in }) -> some View
	{
		return self.background(
			BXKeyEventView(isFocused:isFocused, onKeyDown:down, onKeyUp:up, onModifiersChanged:modifiers)
		)
	}

	/// Executes an action when the Return key is pressed
	
	@ViewBuilder func onReturnKey(_ action:@escaping ()->Void) -> some View
	{
		if #available(macOS 14,*)
		{
			self.onKeyPress(.`return`)
			{
				action()
				return .handled
			}
		}
		else
		{
			self
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
