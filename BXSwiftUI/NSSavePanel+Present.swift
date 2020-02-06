//**********************************************************************************************************************
//
//  NSSavePanel+show.swift
//	Convenience function to show an NSSavePanel
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public extension NSSavePanel
{
	class func presentModal(title:String? = nil, message:String? = nil, buttonLabel:String? = nil, defaultFilename:String? = nil, handler:(URL?)->Void)
	{
		let panel = NSSavePanel()
		
		panel.canCreateDirectories = true
		
		if let title = title
		{
			panel.title = title
		}
		
		if let message = message
		{
			panel.message = message
		}
		
		if let buttonLabel = buttonLabel
		{
			panel.prompt = buttonLabel
		}
		
		if let defaultFilename = defaultFilename
		{
			panel.nameFieldStringValue = defaultFilename
		}
		
		let button = panel.runModal()
		
		if button == NSApplication.ModalResponse.OK
		{
			handler(panel.url)
		}
		else
		{
			handler(nil)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

