//**********************************************************************************************************************
//
//  NSView+Publishers.swift
//	Publishers for view frame/boundsDidChange notifications
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit
import Combine


//----------------------------------------------------------------------------------------------------------------------


public extension NSView
{
	/// Returns a publisher for frame changes of a NSView
	
	var frameDidChange : AnyPublisher<NSRect,Never>
	{
		self.postsFrameChangedNotifications = true
		
		return NotificationCenter.default
			.publisher(for:NSView.frameDidChangeNotification, object:self)
			.compactMap { ($0.object as? NSView)?.frame }
			.eraseToAnyPublisher()
	}

	/// Returns a publisher for bounds changes of a NSView
	
	var boundsDidChange : AnyPublisher<NSRect,Never>
	{
		self.postsBoundsChangedNotifications = true
		
		return NotificationCenter.default
			.publisher(for:NSView.boundsDidChangeNotification, object:self)
			.compactMap { ($0.object as? NSView)?.bounds }
			.eraseToAnyPublisher()
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
