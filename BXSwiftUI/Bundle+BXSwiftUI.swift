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
		return Bundle(for:BXSwiftUIMarker.self)
	}
}


private class BXSwiftUIMarker { }


//----------------------------------------------------------------------------------------------------------------------
