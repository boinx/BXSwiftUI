//**********************************************************************************************************************
//
//  BXDisableWindowDragging.swift
//	A view that suppresses window dragging by clicking on the background
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Wrap controls in this view to stop a click and drag on them from dragging the window.
///
/// Two different mechanisms are needed here, because window dragging itself works differently depending on the
/// system version:
///
/// - Up to macOS 26 AppKit drags the window, so we put an NSView that returns false from mouseDownCanMoveWindow
///   behind the content to opt out.
/// - From macOS 27 on that NSView is never hit tested, because NSHostingView overrides hitTest() and returns
///   itself for every point. There the window is dragged by the WindowDragGesture that
///   bxMovableByWindowBackground() installs at the root of the window, and we opt out by absorbing the drag
///   before it can reach that gesture.

public struct BXDisableWindowDragging<Content:View> : View
{
	// Params
	
	private var content:()->Content
	
	// Init
	
	public init(@ViewBuilder content:@escaping ()->Content)
	{
		self.content = content
	}

	// Build View

	/// The version check has to stay in sync with the one in bxMovableByWindowBackground(), because the two
	/// opt out mechanisms below match the two window dragging mechanisms described above.

	public var body: some View
	{
		if #available(macOS 27.0, *)
		{
			content()
				.background(_BXDisableWindowDragging())

				// This gesture does nothing except swallow the drag, so that it never reaches the
				// WindowDragGesture further up the view tree. Please note that it must be attached with
				// gesture() and not with highPriorityGesture(), because gestures of descendant views need to
				// keep their precedence over it - that is what lets the wrapped controls still work.
				//
				// A minimumDistance of 1 is essential: with 0 this would already engage on mouse down and
				// swallow plain clicks, which would break controls that react to a tap, like BXSegment.

				.gesture( DragGesture(minimumDistance:1).onChanged { _ in } )
		}
		else
		{
			content()
				.background(_BXDisableWindowDragging())
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

struct _BXDisableWindowDragging : NSViewRepresentable
{
	func makeNSView(context:Context) -> __BXDisableWindowDragging
    {
        return __BXDisableWindowDragging(frame:.zero)
    }


	func updateNSView(_ view:__BXDisableWindowDragging, context:Context)
    {

	}
    
//	public class Coordinator : NSObject
//    {
//        var view:BXNoDragView
//
//        init(_ view:BXNoDragView)
//        {
//            self.view = view
//        }
//	}
//
//	public func makeCoordinator() -> Coordinator
//    {
//        return Coordinator(self)
//    }
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

class __BXDisableWindowDragging : NSView
{
	override init(frame:NSRect)
	{
		super.init(frame:frame)
	}
	
	required init?(coder:NSCoder)
	{
		super.init(coder:coder)
	}
	
	override public var mouseDownCanMoveWindow: Bool
	{
		return false
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
