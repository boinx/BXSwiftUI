//**********************************************************************************************************************
//
//  View+DragWindow.swift
//	Controls whether a mouse down on this view can drag the window
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Controls whether a mouse down on this view can drag the window
	
    func canDragWindow(_ isDraggable:Bool = true) -> some View
    {
		self.background(BXDragWindowView(isDraggable:isDraggable))
    }
}
  
  
//----------------------------------------------------------------------------------------------------------------------


/// A SwiftUI helper view that controls whether dragging the window is possible

public struct BXDragWindowView : NSViewRepresentable
{
	var isDraggable = false
	
	public init(isDraggable:Bool = true)
	{
	
	}
	
	public func makeNSView(context:Context) -> _DragWindowView
	{
        let view = _DragWindowView()
        view.isDraggable = self.isDraggable
        view.layer?.borderColor = NSColor.green.cgColor
        view.layer?.borderWidth = 1.0
        return view
    }
  
	public func updateNSView(_ nsView:_DragWindowView, context:Context)
    {
    
    }
}

/// A native helper view that controls whether dragging the window is possible

public class _DragWindowView : NSView
{
	var isDraggable = false
	
	override public var mouseDownCanMoveWindow: Bool
	{
		return isDraggable
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
