//**********************************************************************************************************************
//
//  View+onPaste.swift
//	Adds copy/paste support
//  Copyright ©2025 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit
import UniformTypeIdentifiers


//----------------------------------------------------------------------------------------------------------------------


extension View
{
	/// This modifier function calls the supplied closure when the user pastes a String from the general NSPasteboard
	
    @ViewBuilder public func onPasteString(_ completionHandler:@escaping (String)->Void) -> some View
    {
        if #available(macOS 11, *)
        {
            self.onPasteCommand(of:[UTType.plainText])
			{
				items in

				if let string = NSPasteboard.general.string(forType:.string)
				{
					DispatchQueue.main.async
					{
						completionHandler(string)
					}
				}
			}
        }
        else
        {
			self
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------

#endif
