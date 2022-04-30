//**********************************************************************************************************************
//
//  BXEnclosingScrollViewProxy.swift
//	A helper view that helps with lazy loading of child views
//  Copyright ©2020-2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


/// BXEnclosingScrollViewProxy calls its content builder closure with the visibleRect of the enclosing ScrollView. This can be used to lazily build only those subviews that are actually going to be visible, which is a huge performance win if there are hundreds or even thousands of subviews.

public struct BXEnclosingScrollViewProxy<Content:View> : View
{
	/// Set to true if you want to preserve the scroll position whenever the content size changes.
	
	private var preserveScrollPos:Bool = false
	
	/// The content for the scrollview
	
	private var content:(NSScrollView?,CGRect)->Content
	
	// State
	
	@State private var scrollView:NSScrollView? = nil
	@State private var visibleRect = CGRect.zero

	// Init
	
	public init(preserveScrollPos:Bool = true, @ViewBuilder content:@escaping (NSScrollView?,CGRect)->Content)
	{
		self.preserveScrollPos = preserveScrollPos
		self.content = content
	}

	// Build View

    public var body: some View
    {
		// The content builder can use the visibleRect argument to decide which child views should be
		// created and which children should be skipped because they wouldn't be visible anyways.
		// This can improve performance.
		
		self.content(scrollView,visibleRect)
		
			// Attach a _BXEnclosingScrollViewProxy to track the visibleRect of an enclosingScrollView,
			// i.e. an AppKit NSScrollView
			
			.background(
				_BXEnclosingScrollViewProxy(scrollView:$scrollView, visibleRect:$visibleRect, preserveScrollPos:preserveScrollPos)
			)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

fileprivate struct _BXEnclosingScrollViewProxy : NSViewRepresentable
{
	// Params
	
	var scrollView:Binding<NSScrollView?>
	var visibleRect:Binding<CGRect>
    var preserveScrollPos:Bool = true
    
    // State
    
    @State private var savedScrollPos:CGPoint? = nil
    
    // Build View
    
    func makeNSView(context:Context) -> _TrackingView
    {
		let view = _TrackingView(frame:.zero)
		
		view.scrollView = self.scrollView
		
		view.didChangeSize =
		{
			size in self.saveScrollPos()
		}
		
		view.didScroll =
		{
			visibleRect in
			
			self.restoreScrollPos()

			DispatchQueue.main.async
			{
				self.visibleRect.wrappedValue = visibleRect // Must be deferred to avoid SwiftUI state modification issues during body!
			}
		}
		
		return view
    }

	func updateNSView(_ view:_TrackingView, context:Context)
    {
		
	}
	
	func saveScrollPos()
	{
		guard self.preserveScrollPos else { return }
		guard let scrollView = self.scrollView.wrappedValue else { return }
		self.savedScrollPos = scrollView.contentView.bounds.origin
	}
	
	func restoreScrollPos()
	{
		guard self.preserveScrollPos else { return }
		guard let scrollView = self.scrollView.wrappedValue else { return }
		guard let savedScrollPos = self.savedScrollPos else { return }
		
		scrollView.documentView?.scroll(savedScrollPos)
		self.savedScrollPos = nil
	}
 }


//----------------------------------------------------------------------------------------------------------------------


/// A helper view that tracks the visibleRect of the enclosingScrollView

fileprivate class _TrackingView : NSView
{

	var scrollView:Binding<NSScrollView?>? = nil

	/// Called with the visibleRect whenever the view is scrolled
	
	var didScroll:((CGRect)->Void)? = nil
	
	/// Called when the size of the content changes
	
	var didChangeSize:((CGSize)->Void)? = nil
	
	/// Retains the NotificationCenter observer
	
	var observers:[Any] = []
	
	/// Performs setup when the helper view is added to the view hierarchy
	
	override func viewDidMoveToWindow()
	{
		super.viewDidMoveToWindow()
		guard self.window != nil else { return }
		
		// Find the enclosing NSScrollView and its NSClipView
		
		guard let scrollView = self.enclosingScrollView else { return }
		guard let documentView = scrollView.documentView else { return }
		let clipView = scrollView.contentView

		// Report initial values
		
		self.scrollView?.wrappedValue = scrollView
		self.didChangeSize?(documentView.bounds.size)
		self.didScroll?(clipView.bounds)
		
		// Whenever the content changes, report it new size
		
		documentView.postsFrameChangedNotifications = true

		self.observers += NotificationCenter.default.addAutoRemovingObserver(forName:NSView.frameDidChangeNotification, object:documentView, queue:.main)
		{
			[weak self,weak documentView] _ in
			guard let self = self else { return }
			guard let documentView = documentView else { return }
			self.didChangeSize?(documentView.bounds.size)
		}
		
		// Whenever the view is scrolled, report the new visibleRect
		
		clipView.postsBoundsChangedNotifications = true

		self.observers += NotificationCenter.default.addAutoRemovingObserver(forName:NSView.boundsDidChangeNotification, object:clipView, queue:.main)
		{
			[weak self,weak clipView] _ in
			guard let self = self else { return }
			guard let clipView = clipView else { return }
			self.didScroll?(clipView.bounds)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
