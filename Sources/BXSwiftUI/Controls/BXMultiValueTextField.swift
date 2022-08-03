//**********************************************************************************************************************
//
//  BXMultiValueTextField.swift
//	SwiftUI wrapper for a NSTextfield that supports multiple values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public struct BXMultiValueTextField<T:Hashable> : NSViewRepresentable where T:TypeCheckable
{
	// Params
	
    private var values:Binding<Set<T>>
	private var height:CGFloat? = nil
	private var alignment:TextAlignment = .leading
	private var formatter:Formatter? = nil
	private var selectAllOnMouseDown = true
	private var allowSpaceKey = false
	private var statusHandler:(BXTextFieldStatusHandler)? = nil
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.controlSize) private var controlSize:ControlSize
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName


	// Init
	
	public init(values:Binding<Set<T>>, height:CGFloat? = nil, alignment:TextAlignment = .leading, formatter:Formatter? = nil, selectAllOnMouseDown:Bool = true, allowSpaceKey:Bool = false, statusHandler:(BXTextFieldStatusHandler)? = nil, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.values = values
		self.height = height
		self.alignment = alignment
		self.formatter = formatter
		self.selectAllOnMouseDown = selectAllOnMouseDown
		self.allowSpaceKey = allowSpaceKey
		self.statusHandler = statusHandler
		self.onBegan = onBegan
		self.onEnded = onEnded
	}

	
	// Appearance
	
	private var macControlSize:NSControl.ControlSize
	{
		switch controlSize
		{
			case .regular: 		return .regular
			case .small: 		return .small
			case .mini: 		return .mini
			default: 	return .regular
		}
	}


	/// Creates the underlying BXNativeTextField
	
	public func makeNSView(context:Context) -> BXTextFieldNative
    {
		var action = #selector(Coordinator.updateStringValues(with:))
		
		if T.isDouble
		{
			action = #selector(Coordinator.updateDoubleValues(with:))
		}
		else if T.isInt
		{
			action = #selector(Coordinator.updateIntValues(with:))
		}

        let textfield = BXTextFieldNative(frame:.zero)
        textfield.delegate = context.coordinator
        textfield.alignment = alignment.nstextalignment
        textfield.formatter = formatter
        textfield.controlSize = self.macControlSize
        textfield.fixedHeight = self.height
		textfield.target = context.coordinator
		textfield.action = action
		textfield.selectAllOnMouseDown = self.selectAllOnMouseDown
		textfield.allowSpaceKey = self.allowSpaceKey
		textfield.statusHandler = self.statusHandler
		
		textfield.notify()

		return textfield
    }


	/// Something on the SwiftUI side has changed, so update the NSCustomTextField
	
	public func updateNSView(_ textfield:BXTextFieldNative, context:Context)
    {
		// Do not update the NSTextField value if the user is currently editing
		
		guard !textfield.isEditing else { return }
		
		// Otherwise adopt the value from the data model (source of thruth)
		
		if values.wrappedValue.count == 0
		{
			textfield.stringValue = ""
			textfield.placeholderString = "None"
			textfield.isEnabled = false
		}
		else if values.wrappedValue.count == 1, let value = values.wrappedValue.first
		{
			if let value = value as? String
			{
				textfield.stringValue = value
			}
			else if let value = value as? Double
			{
				textfield.doubleValue = value
			}
			else if let value = value as? Int
			{
				textfield.integerValue = value
			}

			textfield.placeholderString = nil
			textfield.isEnabled = self.isEnabled
		}
		else
		{
			textfield.stringValue = ""
			textfield.placeholderString = "Multiple"
			textfield.isEnabled = self.isEnabled
		}

		textfield.notify()
    }
    
    
    /// Editing has finished in the NSTextField, so update the values on the SwiftUI side
    
	public class Coordinator : NSObject, NSTextFieldDelegate
    {
        var textfield:BXMultiValueTextField<T>
		weak var undoManager:UndoManager?
		var undoName:String

        init(_ textfield:BXMultiValueTextField<T>, _ undoManager:UndoManager?, _ undoName:String)
        {
            self.textfield = textfield
            self.undoManager = undoManager
            self.undoName = undoName
        }

		// The user has started editing. Set isEditing flag to true so that update values in updateNSView
		// can be suppressed, because now the text the user is typing should NOT be replaced with the data model!
		
		public func controlTextDidBeginEditing(_ notification:Notification)
		{
			guard let textfield = notification.object as? BXTextFieldNative else { return }
			textfield.isEditing = true

			self.textfield.onBegan?()
		}

		// The user has ended editing. Update the data model value, then clear the isEditing flag again.

		public func controlTextDidEndEditing(_ notification:Notification)
		{
			guard let textfield = notification.object as? BXTextFieldNative else { return }
			let action = textfield.action
			self.perform(action, with:textfield)
			textfield.isEditing = false
			
			self.textfield.onEnded?()
		}

        @objc func updateStringValues(with sender:NSTextField)
        {
			textfield.values.wrappedValue = Set([sender.stringValue as! T])
			self.undoManager?.setActionName(undoName)
        }
        
        @objc func updateDoubleValues(with sender:NSTextField)
        {
            textfield.values.wrappedValue = Set([sender.doubleValue as! T])
			self.undoManager?.setActionName(undoName)
		}
        
        @objc func updateIntValues(with sender:NSTextField)
        {
            textfield.values.wrappedValue = Set([sender.integerValue as! T])
			self.undoManager?.setActionName(undoName)
        }
    }
    
	public func makeCoordinator() -> Coordinator
    {
        return Coordinator(self, undoManager, undoName)
    }
 }


//----------------------------------------------------------------------------------------------------------------------


#endif
