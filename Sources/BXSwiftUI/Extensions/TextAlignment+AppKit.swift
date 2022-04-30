//**********************************************************************************************************************
//
//  TextAlignment+AppKit.swift
//	Converts TextAlignment from SwiftUI to AppKit
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public extension TextAlignment
{
	/// Returns the corresponding NSTextAlignment for a SwiftUI alignment
	
	var nstextalignment:NSTextAlignment
	{
		switch self
		{
			case .leading:	return .left
			case .center:	return .center
			case .trailing:	return .right
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
