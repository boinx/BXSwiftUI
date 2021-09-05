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
	
	var onKeyDown:(NSEvent)->Void
	var onKeyUp:(NSEvent)->Void
	
	/// AppKit helper view that performs keyboard handling
	
    public class KeyView : NSView
    {
		var onKeyDown:(NSEvent)->Void = { _ in }
		var onKeyUp:(NSEvent)->Void = { _ in }

		// Set this helper view as initialFirstResponder, so that we can restore it when textfields resign
		
		override public func viewDidMoveToWindow()
		{
			self.window?.initialFirstResponder = self
            self.window?.makeFirstResponder(self)
		}
		
        override public var acceptsFirstResponder:Bool
        {
			true
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
    }


	// Create helper view
		
	public func makeNSView(context:Context) -> KeyView
    {
        let view = KeyView(frame:.zero)
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
	
	func onKeyDown(action:@escaping (NSEvent)->Void) -> some View
	{
		return self.background(
			BXKeyEventView(onKeyDown:action, onKeyUp:{_ in})
		)
	}

	/// Adds a keyUp handler to a view
	
	func onKeyUp(action:@escaping (NSEvent)->Void) -> some View
	{
		return self.background(
			BXKeyEventView(onKeyDown:{_ in}, onKeyUp:action)
		)
	}
	
	/// Adds a keyDown/Up handlers to a view
	
	func onKey(down:@escaping (NSEvent)->Void, up:@escaping (NSEvent)->Void) -> some View
	{
		return self.background(
			BXKeyEventView(onKeyDown:down, onKeyUp:up)
		)
	}

}


//----------------------------------------------------------------------------------------------------------------------

#endif
