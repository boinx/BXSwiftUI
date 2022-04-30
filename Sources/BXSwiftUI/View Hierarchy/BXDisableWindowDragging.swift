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
	
	public var body: some View
	{
		content()
			.background(_BXDisableWindowDragging())
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
