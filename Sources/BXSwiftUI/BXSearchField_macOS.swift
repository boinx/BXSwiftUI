//**********************************************************************************************************************
//
//  BXSearchField_macOS.swift
//	SwiftUI wrapper for NSTextField with custom behavior
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


/// BXTextFieldWrapper uses an underlying NSTextField to achieve behavior that isn't supported by SwiftUI
/// as of 10.15 - that is why we drop down to AppKit and implement the desired behavior ourself.

public struct BXSearchFieldWrapper : NSViewRepresentable
{
	// Params
	
	public var value:Binding<String>
	public var placeholderString:String = ""
	public var height:CGFloat? = nil
	public var statusHandler:(BXTextFieldStatusHandler)? = nil
	public var onFocused:((NSSearchField,String)->Void)? = nil
	public var onBegan:((NSSearchField,String)->Void)? = nil
	public var onChanged:((NSSearchField,String)->Void)? = nil
	public var onCommit:((NSSearchField,String)->Void)? = nil
	public var onArrowUpKey:((NSSearchField)->Void)? = nil
	public var onArrowDownKey:((NSSearchField)->Void)? = nil

	// Environment
	
	@Environment(\.controlSize) var controlSize:ControlSize
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// The control size is provided by the environment. needs to be converted to NSControl datatype
	
	private var macControlSize:NSControl.ControlSize
	{
		switch controlSize
		{
//			case .large:		return .large
			case .regular: 		return .regular
			case .small: 		return .small
			case .mini: 		return .mini
			default: 	return .regular
		}
	}

	// Only needed to make init public
	
	public init(value:Binding<String>, placeholderString:String = "", height:CGFloat? = nil, statusHandler:(BXTextFieldStatusHandler)? = nil, onFocused:((NSSearchField,String)->Void)? = nil, onBegan:((NSSearchField,String)->Void)? = nil, onChanged:((NSSearchField,String)->Void)? = nil, onCommit:((NSSearchField,String)->Void)? = nil, onArrowUpKey:((NSSearchField)->Void)? = nil, onArrowDownKey:((NSSearchField)->Void)? = nil)
	{
		self.value = value
		self.height = height 
		self.placeholderString = placeholderString
		self.statusHandler = statusHandler
		self.onFocused = onFocused
		self.onBegan = onBegan
		self.onChanged = onChanged
		self.onCommit = onCommit
		self.onArrowUpKey = onArrowUpKey
		self.onArrowDownKey = onArrowDownKey
	}
	
	
	// Create the underlying NSCustomTextField
	
	public func makeNSView(context:Context) -> BXSearchFieldNative
    {
        let searchfield = BXSearchFieldNative(frame:.zero)
        
        searchfield.delegate = context.coordinator
        searchfield.controlSize = self.macControlSize
        searchfield.alignment = .natural
        searchfield.fixedHeight = self.height
		searchfield.target = context.coordinator
		searchfield.action = #selector(Coordinator.updateStringValue(with:))
		searchfield.isBordered = true
		searchfield.bezelStyle = .roundedBezel
		searchfield.drawsBackground = true
		searchfield.statusHandler = self.statusHandler
		searchfield.onFocused = self.onFocused
		
		return searchfield
    }


	// SwiftUI side has changed, so update the BXSearchFieldNative
	
	public func updateNSView(_ searchfield:BXSearchFieldNative, context:Context)
    {
		// Do not update the NSTextField value if the user is currently editing
		
		let string = self.value.wrappedValue
		if searchfield.isEditing && !string.isEmpty { return }
		
		searchfield.stringValue = string
		searchfield.isEnabled = context.environment.isEnabled

		// Call statusHandler so that clients can update the appearance of the view accordingly
		
		searchfield.notify()
	}
    
    
    // The coordinator is responsible for notifying SwiftUI when editing occured in the BXSearchFieldNative
    
	public class Coordinator : NSObject, NSSearchFieldDelegate
    {
        var searchfield:BXSearchFieldWrapper
		var undoManager:UndoManager?
		var undoName:String
		
        init(_ searchfield:BXSearchFieldWrapper, _ undoManager:UndoManager?, _ undoName:String)
        {
            self.searchfield = searchfield
            self.undoManager = undoManager
            self.undoName = undoName
        }
		
		// The user has started editing. Set isEditing flag to true so that update values in updateNSView
		// can be suppressed, because now the text the user is typing should NOT be replaced with the data model!
		
		public func controlTextDidBeginEditing(_ notification:Notification)
		{
			guard let searchfield = notification.object as? BXSearchFieldNative else { return }
			searchfield.isEditing = true
			self.searchfield.onBegan?(searchfield, searchfield.stringValue)
		}

		// Call the onChanged handler while the user types
		
    	public func controlTextDidChange(_ notification:Notification)
    	{
			guard let searchfield = notification.object as? BXSearchFieldNative else { return }
			self.searchfield.onChanged?(searchfield, searchfield.stringValue)
    	}
    	
		// The user has ended editing
		
		public func controlTextDidEndEditing(_ notification:Notification)
		{
			// Update the data model value, then clear the isEditing flag again.
		
			guard let searchfield = notification.object as? BXSearchFieldNative else { return }
			let action = searchfield.action
			self.perform(action, with:searchfield)
			searchfield.isEditing = false
			
			// Call the commit closure
			
			self.searchfield.onCommit?(searchfield, searchfield.stringValue)

			// Restore initialFirstResponder, so that key event handling works again
			
			DispatchQueue.main.async
			{
				if let window = searchfield.window
				{
					let responder = window.initialFirstResponder
					window.makeFirstResponder(responder)
				}
			}
		}
		
		public func control(_ control:NSControl, textView:NSTextView, doCommandBy commandSelector:Selector) -> Bool
		{
			if let nssearchfield = control as? BXSearchFieldNative
			{
				if commandSelector == #selector(NSControl.moveUp(_:))
				{
					searchfield.onArrowUpKey?(nssearchfield)
					return true
				}
				else if commandSelector == #selector(NSControl.moveDown(_:))
				{
					searchfield.onArrowDownKey?(nssearchfield)
					return true
				}
			}
			
			return false
		}

        @objc func updateStringValue(with sender:NSTextField)
        {
            self.searchfield.value.wrappedValue = sender.stringValue
			self.undoManager?.setActionName(undoName)
        }
 	}
	
	public func makeCoordinator() -> Coordinator
    {
        return Coordinator(self, undoManager, undoName)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// The BXSearchFieldNative subclass provides the desired custom behavior that NSTextField doesn't provide out of the box

public class BXSearchFieldNative : NSSearchField
{
	var statusHandler:(BXTextFieldStatusHandler)? = nil
	var onFocused:((NSSearchField,String)->Void)? = nil
	var trackingArea:NSTrackingArea? = nil
	var isEditing = false { didSet { self.notify() } }
	var fixedHeight:CGFloat? = nil

	override init(frame:NSRect)
	{
		super.init(frame:frame)
	}
	
	required init?(coder:NSCoder)
	{
		super.init(coder:coder)
	}
	
	override public var frame:NSRect
	{
		set
		{
			var f = newValue
			if let h = fixedHeight { f.size.height = h }
			super.frame = f
		}
		
		get
		{
			return super.frame
		}
	}
	
	override public func becomeFirstResponder() -> Bool
	{
		self.onFocused?(self,self.stringValue)
		return super.becomeFirstResponder()
	}
	
	@objc func notify()
	{
		self.statusHandler?(self, self.isEnabled, isEditing, false)
	}
}


//----------------------------------------------------------------------------------------------------------------------


