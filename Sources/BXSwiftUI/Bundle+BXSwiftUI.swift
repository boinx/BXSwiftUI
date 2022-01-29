//**********************************************************************************************************************
//
//  Bundle+BXSwiftUI.swift
//	Adds convenience methods to Bundle
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import Foundation


//----------------------------------------------------------------------------------------------------------------------


extension Bundle
{
	/// Returns the bundle for BXSwiftUI.framework
	
	public class var BXSwiftUI:Bundle
	{
		#if SWIFT_PACKAGE
		return Bundle.module
		#else
		return Bundle(for:BXSwiftUIMarker.self)
		#endif
		
	}
}


private final class BXSwiftUIMarker { }


//----------------------------------------------------------------------------------------------------------------------
