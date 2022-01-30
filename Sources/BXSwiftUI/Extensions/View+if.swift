//**********************************************************************************************************************
//
//  View+if.swift
//	Conditionally apply View modifiers
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Applies the modifiers in the 'modify' closure to self if 'condition' is true. If the 'condition' is false the modifiers will not be applied.
	/// - parameter condition: If true the modifiers will be applied
	/// - parameter modify: A closure that attaches modifiers to the view ($0)
	
	@ViewBuilder func `if`<T:View>(_ condition:Bool, modify:(Self)->T) -> some View
	{
		if condition
		{
			modify(self)
		}
		else
		{
			self
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

