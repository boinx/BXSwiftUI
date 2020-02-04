//**********************************************************************************************************************
//
//  BXEnabledModifier.swift
//	Dims all subviews when this view is not enabled
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXEnabledModifier : ViewModifier
{
	// Params
	
	private var enabledOpactiy = 1.0
	private var disabledOpactiy = 0.33

	// Environment
	
	@Environment(\.isEnabled) var isEnabled

	// Init
	
	public init(enabledOpactiy:Double = 1.0,disabledOpactiy:Double = 0.33) {}
	
	// Modify View
	
	public func body(content:Content) -> some View
    {
        content
			.opacity(isEnabled ? enabledOpactiy : disabledOpactiy)
    }
}


//----------------------------------------------------------------------------------------------------------------------

