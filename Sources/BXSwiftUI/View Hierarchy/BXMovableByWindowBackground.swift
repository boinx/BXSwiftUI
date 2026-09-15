//**********************************************************************************************************************
//
//  BXMovableByWindowBackground.swift
//	Lets the user drag a window by clicking on the background of its SwiftUI content
//  Copyright ©2026 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Lets the user drag the enclosing window by clicking and dragging on the background of this view.
	///
	/// Up to macOS 26 this was handled by AppKit alone: setting NSWindow.isMovableByWindowBackground was enough,
	/// because AppKit hit tests the clicked view and then asks it for mouseDownCanMoveWindow. That no longer works
	/// for SwiftUI content on macOS 27, because NSHostingView overrides hitTest() and returns itself for every
	/// point - AppKit never gets to see a view that permits the drag. For the same reason nested AppKit views are
	/// never hit tested either, which is why BXDisableWindowDragging has become ineffective as well.
	///
	/// So instead of relying on AppKit we let SwiftUI perform the drag. Please note that the gesture is attached
	/// with gesture() and not with highPriorityGesture(), because SwiftUI gives gestures of descendant views
	/// precedence over those of their ancestors. That way buttons, segmented controls, or text views further down
	/// in the view tree still claim their own clicks, just like they did with BXDisableWindowDragging before.
	
	/// Please note that WindowDragGesture is already available from macOS 15 on, but we deliberately only use it
	/// from macOS 27 on - that is where the AppKit mechanism stops working. Do not lower this check without also
	/// lowering the matching one in BXDisableWindowDragging, or the window will be dragged by controls that are
	/// supposed to opt out of it.

	@ViewBuilder func bxMovableByWindowBackground() -> some View
	{
		if #available(macOS 27.0, *)
		{
			self
				.gesture(WindowDragGesture())
				
				// Also drag when the window isn't key yet - the about box and the document chooser are
				// frequently clicked while the app is in the background
				
				.allowsWindowActivationEvents(true)
		}
		else
		{
			self
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
