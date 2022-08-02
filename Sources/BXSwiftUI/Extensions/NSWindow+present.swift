//**********************************************************************************************************************
//
//  NSWindow+present.swift
//	Presents a SwiftUI view in an NSWindow
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension NSWindow
{
	/// Presents a SwiftUI view in a new window with the specified title
	
    @discardableResult class func present<V:View>(_ view:V, title:String = "", minSize:CGSize? = nil, maxSize:CGSize? = nil) -> NSWindow
    {
		// First create a window without any content
		
        let window = Self.init() //NSWindow()
 		var style:NSWindow.StyleMask = []
 		
		if let minSize = minSize
		{
			window.minSize = minSize
		}
		
		if let maxSize = maxSize
		{
			window.maxSize = maxSize
		}
		
		if !title.isEmpty
		{
			style.insert(.titled)
		}
		
		if minSize != maxSize
		{
			style.insert(.resizable)
		}

		if !(window is NSPanel)
		{
			style.insert(.closable)
		}
		
        window.title = title
        window.styleMask = style

		// Inject the window into the view environment
		
		let rootView = view.parentWindow(window)
		
		// Set the window content to an NSHostingController
		
		let controller = NSHostingController(rootView:rootView)
        window.contentViewController = controller
        
        // Present the window
        
        window.center()
		
		if window is NSPanel
		{
			NSApp.runModal(for:window)
		}
		else
		{
			window.makeKeyAndOrderFront(nil)
		}
		
		return window
    }
}


//----------------------------------------------------------------------------------------------------------------------


#endif
