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
import BXUIKit


//----------------------------------------------------------------------------------------------------------------------


public struct BXKeyEventView : NSViewRepresentable
{
	/// Handler closures
	
	var onKeyDown:(NSEvent)->Void
	var onKeyUp:(NSEvent)->Void
	
	/// AppKit helper view that performs keyboard handling
	
    class KeyView : NSView
    {
		var onKeyDown:(NSEvent)->Void = { _ in }
		var onKeyUp:(NSEvent)->Void = { _ in }

        override var acceptsFirstResponder:Bool { true }
        
        override func keyDown(with event:NSEvent)
        {
            self.onKeyDown(event)
        }
        
        override func keyUp(with event:NSEvent)
        {
             self.onKeyUp(event)
        }
    }


	public func makeNSView(context:Context) -> NSView
    {
		// Create helper view
		
        let view = KeyView(frame:.zero)
        view.onKeyDown = self.onKeyDown
        view.onKeyUp = self.onKeyUp
        
        // Wait till next runloop cycle
        
        DispatchQueue.main.async
        {
            view.window?.makeFirstResponder(view)
        }
        
        return view
    }

	public func updateNSView(_ nsView:NSView, context:Context)
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
}


//----------------------------------------------------------------------------------------------------------------------

#endif
