//**********************************************************************************************************************
//
//  NSAppearance+colorScheme.swift
//	Converts an NSAppearance into a SwiftUI ColorScheme
//  Copyright ©2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


extension NSAppearance
{
	/// Returns the corresponding ColorScheme for this NSAppearance
	
	public var colorScheme:ColorScheme
	{
		self.name == .darkAqua ? .dark : .light
	}
}


//----------------------------------------------------------------------------------------------------------------------


