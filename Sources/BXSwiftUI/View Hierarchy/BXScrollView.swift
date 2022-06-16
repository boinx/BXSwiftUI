	//**********************************************************************************************************************
//
//  BXScrollView.swift
//	Wraps an NSScrollView and exposes its features to SwiftUI
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import FotoMagicoCore
import BXSwiftUtils
import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public struct BXScrollView<Content:View> : NSViewRepresentable
{
   	private var scrollPosition:Binding<CGPoint>
   	private var magnification:Binding<CGFloat>
   	private var minMagnification:Binding<CGFloat>
   	private var maxMagnification:Binding<CGFloat>
	private var backgroundColor:NSColor = .white
    private var drawsBackground:Bool = true
    private var hasHorizontalScroller:Bool = true
    private var hasVerticalScroller:Bool = true
    private var allowsMagnification:Bool = true
    private var isCentered:Bool = false
    private var didChangeFrameHandler:((CGRect)->Void)? = nil
	private var content:()->Content
	
	
	/// Wraps an NSScrollView and exposes it properties to SwiftUI via Bindings
	///
	/// - Parameters:
	///   - scrollPosition: Binding to the current scrollPosition
	///   - magnification: Binding to the current magnification
	///   - minMagnification: Binding to the minimum magnification
	///   - maxMagnification: Binding to the maximum magnification
	///   - backgroundColor: The NSScrollView background color
	///   - drawsBackground: Set to false if the NSScrollView should be transparent
	///   - hasVerticalScroller: Set to true if vertical scrolling is allowed
	///   - hasHorizontalScroller: Set to true if horizontal scrolling is allowed
	///   - allowsMagnification: Set to true if zooming is allowed
	///   - contentView: The SwiftUI content view that is embedded in the NSScrollView
	
	public init(scrollPosition:Binding<CGPoint> = .constant(.zero), magnification:Binding<CGFloat> = .constant(1.0), minMagnification:Binding<CGFloat> = .constant(1.0), maxMagnification:Binding<CGFloat> = .constant(1.0), backgroundColor:NSColor = .gray, drawsBackground:Bool = true, hasHorizontalScroller:Bool = true, hasVerticalScroller:Bool = true, allowsMagnification:Bool = true, isCentered:Bool = false, didChangeFrameHandler: ((CGRect)->Void)? = nil, @ViewBuilder content:@escaping ()->Content)
	{
		self.scrollPosition = scrollPosition
		self.magnification = magnification
		self.minMagnification = minMagnification
		self.maxMagnification = maxMagnification
		
		self.backgroundColor = backgroundColor
		self.drawsBackground = drawsBackground
		self.hasVerticalScroller = hasVerticalScroller
		self.hasHorizontalScroller = hasHorizontalScroller
		self.allowsMagnification = allowsMagnification
		self.isCentered = isCentered
		
		self.didChangeFrameHandler = didChangeFrameHandler
		self.content = content
	}
	

	// The Coordinator retains the observers that are necessary to track the scrollPosition
	
	public func makeCoordinator() -> Coordinator
    {
        return Coordinator()
    }

	public class Coordinator : NSObject
    {
		var observers:[Any] = []
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	/// Creates and configures an NSScrollView and embeds the SwiftUI content view
	
	public func makeNSView(context:Context) -> NSScrollView
    {
		// Create a NSScrollView and configure it
		
    	let scrollView = NSScrollView(frame:.zero)

		scrollView.magnification = self.magnification.wrappedValue
		scrollView.minMagnification = self.minMagnification.wrappedValue
		scrollView.maxMagnification = self.maxMagnification.wrappedValue
		scrollView.backgroundColor = self.backgroundColor
		scrollView.drawsBackground = self.drawsBackground
		scrollView.hasVerticalScroller = self.hasVerticalScroller
		scrollView.hasHorizontalScroller = self.hasHorizontalScroller
		scrollView.allowsMagnification = self.allowsMagnification
		
		// If the documentView is supposed to be centered, then install a custom NSClipView subclass
		
		if isCentered
		{
			scrollView.contentView = BXCenteredClipView(frame:.zero)
		}
		
		// Install the SwiftUI content view
		
		let view = NSHostingView(rootView:content())
		view.setFrameSize(view.intrinsicContentSize)
		scrollView.documentView = view

		// Listen to size change notifications
		
		if let didChangeFrameHandler = didChangeFrameHandler
		{
			scrollView.postsFrameChangedNotifications = true
			
			context.coordinator.observers += NotificationCenter.default.publisher(for:NSView.frameDidChangeNotification, object:scrollView).sink
			{
				_ in didChangeFrameHandler(scrollView.frame)
			}
		}
		
		// Listen to scroll & zoom events
		
		scrollView.contentView.postsBoundsChangedNotifications = true
		view.postsFrameChangedNotifications = true
		
		context.coordinator.observers += NotificationCenter.default.publisher(for:NSView.boundsDidChangeNotification, object:scrollView.contentView).sink
		{
			_ in self.scrollPosition.wrappedValue = scrollView.contentView.bounds.origin
		}
		
		context.coordinator.observers += NotificationCenter.default.publisher(for:NSView.frameDidChangeNotification, object:scrollView.documentView).sink
		{
			_ in self.scrollPosition.wrappedValue = scrollView.contentView.bounds.origin
		}
		
		return scrollView
    }


//----------------------------------------------------------------------------------------------------------------------


	// The SwiftUI bindings were modified, so update the NSScrollView
	
	public func updateNSView(_ scrollView:NSScrollView, context:Context)
    {
		scrollView.contentView.scroll(to:self.scrollPosition.wrappedValue)
		scrollView.magnification = self.magnification.wrappedValue
		scrollView.minMagnification = self.minMagnification.wrappedValue
		scrollView.maxMagnification = self.maxMagnification.wrappedValue
    }
}

	
//----------------------------------------------------------------------------------------------------------------------


class BXCenteredClipView:NSClipView
{
	override func constrainBoundsRect(_ proposedBounds:NSRect) -> NSRect
    {

        var rect = super.constrainBoundsRect(proposedBounds)
        
        if let documentView = self.documentView
        {

            if (rect.size.width > documentView.frame.size.width)
            {
                rect.origin.x = (documentView.frame.width - rect.width) / 2
            }

            if(rect.size.height > documentView.frame.size.height)
            {
                rect.origin.y = (documentView.frame.height - rect.height) / 2
            }
        }

        return rect
    }
}


//----------------------------------------------------------------------------------------------------------------------


#endif
