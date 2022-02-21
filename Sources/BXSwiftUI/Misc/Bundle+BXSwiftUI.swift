//**********************************************************************************************************************
//
//  Bundle+BXSwiftUI.swift
//	Access to the BXSwiftUI Bundle
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import Foundation


//----------------------------------------------------------------------------------------------------------------------


public extension Bundle
{
	#if SWIFT_PACKAGE
	static let BXSwiftUI = Bundle.module
	#else
	static let BXSwiftUI = Bundle(identifier:"com.boinx.BXSwiftUI")
	#endif
}


//----------------------------------------------------------------------------------------------------------------------
