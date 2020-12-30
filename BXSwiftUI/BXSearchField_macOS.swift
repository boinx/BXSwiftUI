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
	public var onCommit:((NSSearchField,String)->Void)? = nil

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
	
	public init(value:Binding<String>, placeholderString:String = "", height:CGFloat? = nil, statusHandler:(BXTextFieldStatusHandler)? = nil, onCommit:((NSSearchField,String)->Void)? = nil)
	{
		self.value = value
		self.height = height 
		self.placeholderString = placeholderString
		self.statusHandler = statusHandler
		self.onCommit = onCommit
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
		
		return searchfield
    }


	// SwiftUI side has changed, so update the BXSearchFieldNative
	
	public func updateNSView(_ searchfield:BXSearchFieldNative, context:Context)
    {
		// Do not update the NSTextField value if the user is currently editing
		
		guard !searchfield.isEditing else { return }
		
		searchfield.stringValue = self.value.wrappedValue
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
			guard let textfield = notification.object as? BXTextFieldNative else { return }
			textfield.isEditing = true
		}

		// The user has ended editing. Update the data model value, then clear the isEditing flag again.
		
		public func controlTextDidEndEditing(_ notification:Notification)
		{
			guard let searchfield = notification.object as? BXSearchFieldNative else { return }
			let action = searchfield.action
			self.perform(action, with:searchfield)
			searchfield.isEditing = false
			
			self.searchfield.onCommit?(searchfield,searchfield.stringValue)

			DispatchQueue.main.async
			{
				searchfield.window?.makeFirstResponder(nil)
			}
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
	
	@objc func notify()
	{
		self.statusHandler?(self, self.isEnabled, isEditing, false)
	}
}


//----------------------------------------------------------------------------------------------------------------------


