//**********************************************************************************************************************
//
//  NSAlert+Present.swift
//	Convenience function to show an NSAlert
//  Copyright ©2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public extension NSAlert
{
	class func presentModal(title:String, message:String, okButton:String = "OK", cancelButton:String? = nil, appearance:NSAppearance? = nil, okHandler:(()->Void)? = nil)
	{
		let alert = NSAlert()
		
		alert.window.appearance = appearance
		alert.messageText = title
		alert.informativeText = message
		alert.addButton(withTitle:okButton)
		
		if let cancelButton = cancelButton
		{
			alert.addButton(withTitle:cancelButton)
		}
		
		if alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
		{
			okHandler?()
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
