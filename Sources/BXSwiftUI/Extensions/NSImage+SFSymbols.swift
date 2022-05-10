//**********************************************************************************************************************
//
//  NSImage+Extensions.swift
//	Adds convenience methods
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit
import CoreImage


//----------------------------------------------------------------------------------------------------------------------


public extension NSImage
{
	/// Creates a new NSImage for the specified SFSymbol name
	
	convenience init?(systemName:String)
	{
		// On Big Sur or newer use the system SF Symbols
		
		if #available(macOS 11, *)
		{
			self.init(systemSymbolName:systemName, accessibilityDescription:nil)
		}
		
		// On macOS Catalina use our own fallback images that are shipped with the package resources
		
		else
		{
			guard let url = Bundle.BXSwiftUI.url(forResource:systemName, withExtension:nil) else { return nil }
			self.init(contentsOf:url)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
