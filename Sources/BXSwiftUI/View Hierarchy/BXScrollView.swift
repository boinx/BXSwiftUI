	//**********************************************************************************************************************
//
//  BXScrollView.swift
//	Wraps an NSScrollView and exposes its features to SwiftUI
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

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
	
	public init(scrollPosition:Binding<CGPoint> = .constant(.zero), magnification:Binding<CGFloat> = .constant(1.0), minMagnification:Binding<CGFloat> = .constant(1.0), maxMagnification:Binding<CGFloat> = .constant(1.0), backgroundColor:NSColor = .gray, drawsBackground:Bool = true, hasHorizontalScroller:Bool = true, hasVerticalScroller:Bool = true, allowsMagnification:Bool = false, isCentered:Bool = false, didChangeFrameHandler: ((CGRect)->Void)? = nil, @ViewBuilder content:@escaping ()->Content)
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
		
		let updateScrollViewSize = { self.update(scrollView, newContentSize:$0) }
		
		let content = content()
			.environment(\.bxUpdateScrollViewSize, updateScrollViewSize)
			
		let view = NSHostingView(rootView:content)
		scrollView.documentView = view

		DispatchQueue.main.async
		{
			updateScrollViewSize(view.intrinsicContentSize)
		}
		
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
			_ in
			DispatchQueue.main.async
			{
				self.scrollPosition.wrappedValue = scrollView.contentView.bounds.origin
			}
		}
		
		context.coordinator.observers += NotificationCenter.default.publisher(for:NSView.frameDidChangeNotification, object:scrollView.documentView).sink
		{
			_ in
			DispatchQueue.main.async
			{
				self.scrollPosition.wrappedValue = scrollView.contentView.bounds.origin
			}
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
    
    
    /// Resizes the documentView of the NSScrollView to the new size
	
    internal func update(_ scrollView:NSScrollView, newContentSize:CGSize)
    {
		guard let documentView = scrollView.documentView else { return }
		
 		var bounds = scrollView.contentView.bounds
 		let oldContentSize = documentView.frame.size
		documentView.setFrameSize(newContentSize)
		
		// If the view is centered, then try to keep the center of the visible
		// portion of the view centered after the zoom has happened.
		
		if self.isCentered
		{
			let factor = (newContentSize.width / oldContentSize.width).validated(fallbackValue:1.0)
			bounds.origin.x = factor * bounds.midX - 0.5 * bounds.width // / factor
			bounds.origin.y = factor * bounds.midY - 0.5 * bounds.height // / factor
			scrollView.contentView.bounds = bounds
		}
    }
}

	
//----------------------------------------------------------------------------------------------------------------------


class BXCenteredClipView:NSClipView
{
	// This override makes sure that the documentView is centered within the
	// NSScrollView if it is smaller than the NSScrollView itself.
	
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


// MARK: -

public extension EnvironmentValues
{
    var bxUpdateScrollViewSize:((CGSize)->Void)?
    {
        set { self[BXUpdateScrollViewSizeKey.self] = newValue }
        get { return self[BXUpdateScrollViewSizeKey.self] }
    }
}

struct BXUpdateScrollViewSizeKey : EnvironmentKey
{
    static let defaultValue:((CGSize)->Void)? = { _ in }
}


//----------------------------------------------------------------------------------------------------------------------


#endif
