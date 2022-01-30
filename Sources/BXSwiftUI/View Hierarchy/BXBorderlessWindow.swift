//**********************************************************************************************************************
//
//  BXBorderlessWindow.swift
//	A borderless NSWindow subclass with SwiftUI content
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import AppKit
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


open class BXBorderlessWindow : NSWindow, ObservableObject
{
    /// Creates a NSWindow with the specified SwiftUI view as contents
    
    public init<V:View>(with view:V)
    {
		// Create a borderless window
	
 		super.init(
			contentRect:CGRect(x:0, y:0, width:300, height:200),
			styleMask:[.borderless,.fullSizeContentView],
			backing:.buffered,
			defer:false)

		self.isMovableByWindowBackground = true
		self.isReleasedWhenClosed = true
		
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

    override open var canBecomeMain : Bool
    {
		return true
    }

}


//----------------------------------------------------------------------------------------------------------------------
