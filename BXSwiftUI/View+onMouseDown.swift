//**********************************************************************************************************************
//
//  View+onMouseDown.swift
//	Attaches a handler that is called when a mouse click occurs
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// A ViewModifier that that calls a handler when a mouse down (tap) occurs on a view

public struct BXMouseDownModifier : ViewModifier
{
	// Params
	
	private var onMouseDown:(CGPoint)->Void
	
	// State
	
	@State private var iteration = 0

	// Init
	
	public init(onMouseDown:@escaping (CGPoint)->Void)
	{
		self.onMouseDown = onMouseDown
	}
	
	// Modify View
	
	public func body(content:Content) -> some View
    {
		// Use a DragGesture because onChanged is called immediately upon mouseDown, whereas the simpler
		// onTapGesture is only called on mouseUp, which is not a good UX for time-critical user interfaces.
		
        content.simultaneousGesture( DragGesture(minimumDistance:0.0)
			
			.onChanged
			{
				if self.iteration == 0
				{
					self.onMouseDown($0.location)
				}
				
				self.iteration += 1
			}
			.onEnded
			{
				_ in self.iteration = 0
			}
		)
    }
}


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Attaches a handler that is called when a mouse click occurs on the View
	
	func onMouseDown(_ handler:@escaping (CGPoint)->Void) -> some View
	{
		self.modifier(BXMouseDownModifier(onMouseDown:handler))
	}
}


//----------------------------------------------------------------------------------------------------------------------
