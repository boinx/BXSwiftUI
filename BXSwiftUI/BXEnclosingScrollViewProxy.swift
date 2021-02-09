//**********************************************************************************************************************
//
//  BXEnclosingScrollViewProxy.swift
//	A helper view that helps with lazy loading of child views
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


/// BXEnclosingScrollViewProxy calls its content builder closure with the visibleRect of the enclosing ScrollView. This

public struct BXEnclosingScrollViewProxy<Content:View> : View
{
	private var content:(CGRect)->Content
	@State private var visibleRect = CGRect.zero

	// Init
	
	public init(@ViewBuilder content:@escaping (CGRect)->Content)
	{
		self.content = content
	}

	// Build View

    public var body: some View
    {
		// The content builder can use the visibleRect argument to decide which child views should be
		// created and which children should be skipped because they wouldn't be visible anyways.
		// This can improve performance.
		
		self.content(visibleRect)
		
			// Attach a _BXEnclosingScrollViewProxy to track the visibleRect of an enclosingScrollView,
			// i.e. an AppKit NSScrollView
			
			.background(
				_BXEnclosingScrollViewProxy(visibleRect:$visibleRect)
			)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

fileprivate struct _BXEnclosingScrollViewProxy : NSViewRepresentable
{
	/// A binding to the @State from above
	
	var visibleRect:Binding<CGRect>
    
    // Build View
    
    func makeNSView(context:Context) -> _TrackingView
    {
		let view = _TrackingView(frame:.zero)
		
		view.didScrollHandler =
		{
			visibleRect in
			DispatchQueue.main.async { self.visibleRect.wrappedValue = visibleRect } // Must be deferred to avoid SwiftUI state modification issues during body!
		}
		
		return view
    }

	func updateNSView(_ view:_TrackingView, context:Context)
    {
		
	}
 }


//----------------------------------------------------------------------------------------------------------------------


/// A helper view that tracks the visibleRect of the enclosingScrollView

fileprivate class _TrackingView : NSView
{
	/// The visibleRec tof the enclosingScrollView is reported by the didScrollHandler closure
	
	var didScrollHandler:((CGRect)->Void)? = nil
	
	/// Retains the NotificationCenter observer
	
	var observer:Any? = nil
	
	/// Performs setup when the helper view is added to the view hierarchy
	
	override func viewDidMoveToWindow()
	{
		super.viewDidMoveToWindow()
		guard self.window != nil else { return }
		
		// Find the enclosing NSScrollView and its NSClipView
		
		guard let scrollView = self.enclosingScrollView else { return }
		let clipView = scrollView.contentView
		
		// Call the didScrollHandler with the initial visibleRect
		
		self.didScrollHandler?(clipView.bounds)

		// Whenever the view is scrolled, call the didScrollHandler with the new visibleRect
		
		clipView.postsBoundsChangedNotifications = true

		self.observer = NotificationCenter.default.addAutoRemovingObserver(forName:NSView.boundsDidChangeNotification, object:clipView, queue: OperationQueue.main)
		{
			[weak self,weak clipView] _ in
			guard let self = self else { return }
			guard let clipView = clipView else { return }
			self.didScrollHandler?(clipView.bounds)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
