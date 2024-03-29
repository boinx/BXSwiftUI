//**********************************************************************************************************************
//
//  NSViewController+Embed.swift
//	Convenience function to embed SwiftUI views
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public extension NSViewController
{
	/// Embeds a SwiftUI view in a NSView hierarchy.
	/// - parameter view: The SwiftUI view to embed
	/// - parameter containerView: If will be embedded below this view
	
	func embedSwiftUI<V:View>(_ view:V, in containerView:NSView)
	{
		let hostingView = NSHostingView(rootView:view)
		containerView.addSubview(hostingView)

		hostingView.translatesAutoresizingMaskIntoConstraints = false
		
		hostingView.topAnchor.constraint(equalTo:containerView.topAnchor).isActive = true
		hostingView.bottomAnchor.constraint(equalTo:containerView.bottomAnchor).isActive = true
		hostingView.leadingAnchor.constraint(equalTo:containerView.leadingAnchor).isActive = true
		hostingView.trailingAnchor.constraint(equalTo:containerView.trailingAnchor).isActive = true
	}
	
	/// Removes the specified SwiftUI view from the view hierarchy. This breaks possible retain cycles, if the SwiftUI view was
	/// referencing its owner via @ObservedObject or @Binding.
	/// - parameter view: The SwiftUI view to remove from the view hierarchy
	/// - parameter containerView: It will be removed from this view
	
	func removeSwiftUI<V:View>(_ view:V?, from containerView:NSView)
	{
		for subview in containerView.subviews
		{
			if subview is NSHostingView<V>
			{
				subview.removeFromSuperview()
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
