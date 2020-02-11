//**********************************************************************************************************************
//
//  View+Cursor.swift
//	An extension that attaches macOS cursor to views
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import Combine
import AppKit


//----------------------------------------------------------------------------------------------------------------------


// Public API

public extension View
{
	/// Sets a cursor for a specific modifier key combination
	
    func cursor(_ cursor:NSCursor, for flags:NSEvent.ModifierFlags) -> some View
    {
//		let key = flags.deviceIndependent
		return self.background(BXCursorView([flags:cursor]))
    }

	/// Set cursors for multiple modifier key combinations
	
    func cursors(_ cursors:[NSEvent.ModifierFlags:NSCursor]) -> some View
    {
		return self.background(BXCursorView(cursors))
    }
}
  
  
//----------------------------------------------------------------------------------------------------------------------


extension NSEvent.ModifierFlags : Hashable
{
	// Add Hashable support to ModifierFlags

	public var hashValue: Int { self.rawValue.hashValue }
	
	// Mask away device dependent flags that interfere with using this as a dictionary key

	public var deviceIndependent : Self
	{
		return self.intersection(Self.deviceIndependentFlagsMask)
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

// Create underlying AppKit NSView

public struct BXCursorView : NSViewRepresentable
{
    private let cursors:[NSEvent.ModifierFlags:NSCursor]
	
    init(_ cursors:[NSEvent.ModifierFlags:NSCursor])
    {
        self.cursors = cursors
    }
  
	public func makeNSView(context:Context) -> _BXCursorView
	{
        let view = _BXCursorView()
        view.cursors = self.cursors
        return view
    }
  
	public func updateNSView(_ view:_BXCursorView, context:Context)
    {

    }
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

// This subclass detects mouseEntered and mouseExited and notifies BXCursorViewTracker accordingly

public class _BXCursorView : NSView
{
	var cursors:[NSEvent.ModifierFlags:NSCursor] = [:]
	var trackingArea:NSTrackingArea? = nil
	
	override open func updateTrackingAreas()
	{
		if let trackingArea = self.trackingArea
		{
			self.removeTrackingArea(trackingArea)
		}
		
		let trackingArea = NSTrackingArea(rect:self.bounds, options:[.mouseEnteredAndExited,.mouseMoved,.assumeInside,.activeInKeyWindow], owner:self, userInfo:nil)
		self.addTrackingArea(trackingArea)
		self.trackingArea = trackingArea
	}
	
	override public func mouseEntered(with event:NSEvent)
	{
		BXCursorViewTracker.shared.enter(self)
	}

	override public func mouseMoved(with event:NSEvent)
	{
		BXCursorViewTracker.shared.moved(self)
	}

	override public func mouseExited(with event:NSEvent)
	{
		BXCursorViewTracker.shared.exit(self)
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -


// Unfortunately NSView.mouseEntered() and NSView.mouseExited() calling order is not what you would expect when
// view are overlapping or one is a subview of another. The calls are out of order so NSCursor push/pop stacks
// cannot be used reliably. For this reason we introduce a singleton BXCursorViewTracker that reliably keeps
// track of the view that the mouse is currently over.

class BXCursorViewTracker
{
	static let shared = BXCursorViewTracker()
	
	/// Returns the cursors for currentView
	
	private var cursors:[NSEvent.ModifierFlags:NSCursor] = [:]
	
	/// An subscriber to modifier key presses
	
	private var modifierKeySubscriber:AnyCancellable? = nil
	
	/// Returns the view that the mouse is currently over
	
	private var currentView:_BXCursorView? = nil
	{
		didSet
		{
			if currentView != oldValue { self.updateCursor() }
		}
	}
	
	// Subscribe to modifier key presses
	
	init()
	{
		self.modifierKeySubscriber = BXModifierKeys.shared.objectWillChange.sink
		{
			self.updateCursor()
		}
	}

	// Track the view that the mouse is currently over. Handle an unexpected
	// order of calls tomouseEntered and mouseExited gracefully.
	
	func enter(_ view:_BXCursorView)
	{
		self.currentView = view
	}
	
	func moved(_ view:_BXCursorView)
	{
		self.currentView = view
	}
	
	func exit(_ view:_BXCursorView)
	{
		if currentView == view
		{
			self.currentView = nil
		}
	}
	
	// Update the cursor for the current view and modifier keys
	
	func updateCursor()
	{
		let key = BXModifierKeys.shared.flags.deviceIndependent
		self.cursors = currentView?.cursors ?? [:]
		let currentCursor = self.cursors[key] ?? NSCursor.arrow
		currentCursor.set()
	}
}


//----------------------------------------------------------------------------------------------------------------------
