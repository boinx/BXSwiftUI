//**********************************************************************************************************************
//
//  NSAlert+Present.swift
//	Convenience function to show an NSAlert
//  Copyright ©2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


//----------------------------------------------------------------------------------------------------------------------


#if os(macOS)

import AppKit

public extension NSAlert
{
	/// Convenience function to show a modal alert with the specified arguments
	
	class func presentModal(style:NSAlert.Style = .informational, title:String, message:String, okButton:String = "OK", cancelButton:String? = nil, suppressionKey:String? = nil, appearance:NSAppearance? = nil, okHandler:(()->Void)? = nil)
	{
		// Bail out if the user clicked on the "Don't show again" checkbox
		
		if let suppressionKey = suppressionKey, UserDefaults.standard.bool(forKey:suppressionKey)
		{
			return
		}

		// Create the alert
		
		let alert = NSAlert()
    	alert.alertStyle = style
		alert.window.appearance = appearance
		alert.messageText = title
		alert.informativeText = message
		alert.addButton(withTitle:okButton)
		alert.showsSuppressionButton = suppressionKey != nil
		
		if let cancelButton = cancelButton
		{
			alert.addButton(withTitle:cancelButton)
		}
		
		// Show modal alert
		
		if alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
		{
			okHandler?()
		}
		
		// If the user clicked on the suppression checkbox, then store info in prefs
		
		if let suppressionKey = suppressionKey, let checkbox = alert.suppressionButton, checkbox.state == .on
		{
			UserDefaults.standard.set(true, forKey:suppressionKey)
		}
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------


#if os(iOS)

import UIKit

public extension UIViewController
{
	func presentAlert(title:String, message:String, okButton:String = "OK", cancelButton:String? = nil, okHandler:(()->Void)? = nil)
	{
		let alert = UIAlertController(title:title, message:message, preferredStyle:.alert)
		
		alert.addAction( UIAlertAction(title:okButton, style:.default)
		{
			_ in okHandler?()
		})

		alert.addAction( UIAlertAction(title:cancelButton, style:.cancel)
		{
			_ in okHandler?()
		})

		self.present(alert, animated:true, completion: nil)
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------
