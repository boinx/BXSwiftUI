//**********************************************************************************************************************
//
//  NSViewController+Embed.swift
//	Convenience function to embed SwiftUI views
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public extension NSViewController
{
	/// Embeds a SwiftUI view in a NSView hierarchy.
	/// - parameter view: The SwiftUI view to embed
	/// - parameter rootView: If will be embedded below this view
	
	func embedSwiftUI<V:View>(_ view:V, at rootView:NSView)
	{
		let hostingView = NSHostingView(rootView:view)
		self.view.addSubview(hostingView)

		hostingView.translatesAutoresizingMaskIntoConstraints = false
		
		hostingView.topAnchor.constraint(equalTo:rootView.topAnchor).isActive = true
		hostingView.bottomAnchor.constraint(equalTo:rootView.bottomAnchor).isActive = true
		hostingView.leadingAnchor.constraint(equalTo:rootView.leadingAnchor).isActive = true
		hostingView.trailingAnchor.constraint(equalTo:rootView.trailingAnchor).isActive = true
	}
}


//----------------------------------------------------------------------------------------------------------------------


