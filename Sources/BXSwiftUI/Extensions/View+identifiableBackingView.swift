//**********************************************************************************************************************
//
//  View+identifiableBackingView.swift
//	Adds a helper NSView with a specified ID
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if canImport(AppKit)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


extension View
{
	/// This modifier adds a (transparent) background NSView with the specified identifier.
	///
	/// This background view doesn't have any functionality except that it lets you traverse the NSView hierarchy of a window and find this
	/// view by identifier. That way the frame of SwiftUI views can be located at runtime.
	
	public func identifiableBackingView(withID id:String) -> some View
	{
		self.background(
			BXIdentifierHelperView(id:id)
		)
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXIdentifierHelperView : NSViewRepresentable
{
	public var id:String
	
	public init(id:String)
	{
		self.id = id
	}
	
	public func makeNSView(context:Context) -> NSView
    {
        let helperView = NSView(frame:.zero)
        helperView.identifier = NSUserInterfaceItemIdentifier(id)
		return helperView
    }
    
	public func updateNSView(_ nsView:NSView, context:Context)
	{
	
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
