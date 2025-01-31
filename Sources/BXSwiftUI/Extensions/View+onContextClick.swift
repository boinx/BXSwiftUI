//**********************************************************************************************************************
//
//  View+onContextClick.swift
//	Calls a closure before context menu clicks are handled
//  Copyright ©2025 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


extension View
{
	/// Calls the supplied action closure if a context menu click occurs with the view bounds rect.
	///
	/// Please note that the action is called **before** the event is handled by the application, and before any context menus
	/// are shown, so you can prepare as necessary.
	
	public func onContextClick(_ action:@escaping ()->Void) -> some View
	{
		self.background( BXContextClickView(action) )
	}
}


//----------------------------------------------------------------------------------------------------------------------


/// A helper view that installs a local event monitor to detect context menu clicks

public struct BXContextClickView : NSViewRepresentable
{
	var action:()->Void
	
	public init(_ action:@escaping ()->Void)
	{
		self.action = action
	}
	
	public func makeNSView(context:Context) -> _BXContextClickView
	{
        return _BXContextClickView(action:action)
    }
  
	public func updateNSView(_ nsView:_BXContextClickView, context:Context)
    {
    
    }
}


//----------------------------------------------------------------------------------------------------------------------


/// A helper view that installs a local event monitor to detect context menu clicks

public class _BXContextClickView : NSView
{
	var action:()->Void
	var eventMonitor:Any? = nil
	
	public init(action:@escaping ()->Void)
	{
		self.action = action
		
		super.init(frame:.zero)
		
		// Install an event monitor for mouse clicks
		
		self.eventMonitor = NSEvent.addLocalMonitorForEvents(matching:[.leftMouseDown,.rightMouseDown])
		{
			event in
			
			// Check if this is a context menu click
			
			guard event.type == .rightMouseDown ||
			     (event.type == .leftMouseDown && event.modifierFlags.contains(.control)) else { return event }
			  
			// Check if it occured with our view bounds
			
			var mouse = event.locationInWindow
			mouse = self.convert(mouse, from:nil)
			guard self.bounds.contains(mouse) else { return event }
			
			// Yes, so perform action
			
			action()
			
			// Return the event, so that it gets handled in standard fashion by the app runloop
			
			return event
		}
	}
	
	required init?(coder:NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit
	{
		// Remove the event monitor when the view disappears
		
		if let monitor = self.eventMonitor
		{
			NSEvent.removeMonitor(monitor)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
