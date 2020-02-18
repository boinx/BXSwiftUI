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
	@Environment(\.hasReducedOpacityAncestor) var hasReducedOpacityAncestor

	// Init
	
	public init(enabledOpactiy:Double = 1.0,disabledOpactiy:Double = 0.33) {}
	
	// Modify View
	
	public func body(content:Content) -> some View
    {
        content
			.opacity(self.opacity)
			.hasReducedOpacityAncestor(!isEnabled)
    }
    
    var opacity : Double
    {
		// If we already have an ancestor with reduced opacity, we do not need to do it again!
		
		if hasReducedOpacityAncestor
		{
			return enabledOpactiy
		}
		
		// Otherwise choose between enabled or disabled opacity
		
		return isEnabled ? enabledOpactiy : disabledOpactiy
    }
}


//----------------------------------------------------------------------------------------------------------------------


// This environment key stores info about which node in the view tree has reduced opacity due to being disabled.
// Any children below that do not need to (and should not) reduce opacity any further.

public struct BXHasReducedOpacityAncestorKey : EnvironmentKey
{
    static public let defaultValue:Bool = false
}

public extension EnvironmentValues
{
    var hasReducedOpacityAncestor:Bool
    {
        set
        {
            self[BXHasReducedOpacityAncestorKey.self] = newValue
        }

        get
        {
            return self[BXHasReducedOpacityAncestorKey.self]
        }
    }
}

public extension View
{
	func hasReducedOpacityAncestor(_ hasReducedOpacityAncestor:Bool) -> some View
    {
        self.environment(\.hasReducedOpacityAncestor, hasReducedOpacityAncestor)
    }
}


//----------------------------------------------------------------------------------------------------------------------

