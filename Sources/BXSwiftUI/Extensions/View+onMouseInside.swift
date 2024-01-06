//**********************************************************************************************************************
//
//  View+onMouseInside.swift
//	More reliable implementation of Apple's onHover
//  Copyright ©2024 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// This is a more reliable implementation than the standard SwiftUI .onHover modifier, which doesn't work if the mouse is already inside when the view
/// appears.
///
/// Based on https://gist.github.com/importRyan/c668904b0c5442b80b6f38a980595031

extension View
{
    public func onMouseInside(_ onMouseInsideHandler:@escaping (Bool)->Void) -> some View
    {
        self.modifier(MouseInsideModifier(onMouseInsideHandler))
    }
}
	

//----------------------------------------------------------------------------------------------------------------------


struct MouseInsideModifier : ViewModifier
{
    let onMouseInsideHandler:(Bool)->Void
    
    init(_ onMouseInsideHandler:@escaping (Bool)->Void)
    {
        self.onMouseInsideHandler = onMouseInsideHandler
    }
    
    func body(content:Content) -> some View
    {
        content.background(
			BXTrackableView(onMouseInsideHandler:onMouseInsideHandler)
        )
    }
    
    // Use an NSView with NSTrackingArea to get a reliable implementation
    
    private struct BXTrackableView : NSViewRepresentable
    {
        let onMouseInsideHandler:(Bool)->Void
        
        func makeNSView(context:Context) -> NSView
        {
            let view = NSView(frame:.zero)
            
            let options: NSTrackingArea.Options =
            [
                .mouseEnteredAndExited,
                .inVisibleRect,
                .activeInKeyWindow,
                .assumeInside
            ]
            
            let trackingArea = NSTrackingArea(
				rect:view.frame,
				options:options,
				owner:context.coordinator,
				userInfo:nil)
            
            view.addTrackingArea(trackingArea)
            
            return view
        }
        
        func updateNSView(_ nsView:NSView, context:Context)
        {
        
		}
        
        static func dismantleNSView(_ nsView:NSView, coordinator:Coordinator)
        {
            nsView.trackingAreas.forEach { nsView.removeTrackingArea($0) }
        }

        func makeCoordinator() -> Coordinator
        {
            let coordinator = Coordinator()
            coordinator.onMouseInsideHandler = onMouseInsideHandler
            return coordinator
        }
        
        class Coordinator: NSResponder
        {
            var onMouseInsideHandler:((Bool)->Void)? = nil
            
            override func mouseEntered(with event:NSEvent)
            {
                onMouseInsideHandler?(true)
            }
            
            override func mouseExited(with event:NSEvent)
            {
                onMouseInsideHandler?(false)
            }
        }
        
    }
}


//----------------------------------------------------------------------------------------------------------------------
