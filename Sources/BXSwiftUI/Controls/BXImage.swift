//**********************************************************************************************************************
//
//  BXImage.swift
//	Provides fallback solutions when running on macOS Catalina
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// BXImage works similar to SwiftUI.Image, except that it provides backwards compatibilty for macOS Catalina.
/// Unfortunately SF Symbols didn't ship on macOS until macOS Big Sur, so when running on Catalina, a fallback
/// solution is needed. BXImage uses its won icon resources in this case.

public struct BXImage : View
{
	// Params
	
	private var name:String

	// Init
	
	public init(systemName:String)
	{
		self.name = systemName
	}
	
	// Build View
	
	public var body: some View
	{
		// On Big Sur or newer use the system SF Symbols
		
		if #available(macOS 11, iOS 14, *)
		{
			SwiftUI.Image(systemName:name)
		}
		
		// On macOS Catalina use our own fallback images that are shipped with the package resources
		
		else if Bundle.BXSwiftUI.image(forResource:name) != nil
		{
			SwiftUI.Image(name, bundle:Bundle.BXSwiftUI)
		}
		else
		{
			SwiftUI.Image("stop", bundle:Bundle.BXSwiftUI) 	// fallback for unavailable icon
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
