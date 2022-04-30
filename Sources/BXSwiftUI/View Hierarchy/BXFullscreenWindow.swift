//**********************************************************************************************************************
//
//  BXFullscreenWindow.swift
//	A borderless NSWindow subclass with SwiftUI content
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public class BXFullscreenWindow : NSWindow, ObservableObject
{
    /// Creates a borderless fullscreen NSWindow with the specified SwiftUI view as contents
    
    public init<V:View>(for screen:NSScreen, with view:V)
    {
		// Create window
	
 		super.init(
			contentRect:screen.frame,
			styleMask:[.borderless,.fullSizeContentView],
			backing:.buffered,
			defer:false)

		self.isMovableByWindowBackground = false
		self.isReleasedWhenClosed = true
		self.setFrame(screen.frame, display:true)
		
		// Install rootView
		
		let rootView = NSView(frame:.zero)
		self.contentView = rootView
		
		// Install SwiftUI content in a NSHostingView
		
		let hostingView = NSHostingView(rootView:view.environmentObject(self))
		rootView.addSubview(hostingView)
	
		hostingView.translatesAutoresizingMaskIntoConstraints = false
		hostingView.topAnchor.constraint(equalTo:rootView.topAnchor).isActive = true
		hostingView.bottomAnchor.constraint(equalTo:rootView.bottomAnchor).isActive = true
		hostingView.leadingAnchor.constraint(equalTo:rootView.leadingAnchor).isActive = true
		hostingView.trailingAnchor.constraint(equalTo:rootView.trailingAnchor).isActive = true
    }
    
    // Override to make sure that borderless window can accept keyboard events
    
    override open var canBecomeKey : Bool
    {
		return true
    }
}


//----------------------------------------------------------------------------------------------------------------------

#endif
