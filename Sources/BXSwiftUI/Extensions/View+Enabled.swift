//**********************************************************************************************************************
//
//  View+enabled.swift
//	Adds enabled() modifier to View
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


extension View
{
	/// Enables the view hierarchy if the supplied flag is true
	
	public func enabled(_ isEnabled:Bool) -> some View
	{
		return self.disabled(!isEnabled)
	}
	
	/// Enables the view hierarchy if any of the supplied flags is true
	
	public func enabled(_ enabled:Array<Bool>) -> some View
	{
		let isEnabled = enabled.reduce(false) { $0 || $1 }
		return self.disabled(!isEnabled)
	}

	/// Enables the view hierarchy if any of the supplied flags is true
	
	public func enabled(_ enabled:Set<Bool>) -> some View
	{
		let isEnabled = enabled.reduce(false) { $0 || $1 }
		return self.disabled(!isEnabled)
	}
	
	/// Disables the view hierarchy if all of the supplied flags are true
	
	public func disabled(_ disabled:Array<Bool>) -> some View
	{
		let isDisabled = disabled.reduce(true) { $0 && $1 }
		return self.disabled(!isDisabled)
	}

	/// Disables the view hierarchy if all of the supplied flags are true
	
	public func disabled(_ disabled:Set<Bool>) -> some View
	{
		let isDisabled = disabled.reduce(true) { $0 && $1 }
		return self.disabled(isDisabled)
	}
}


//----------------------------------------------------------------------------------------------------------------------
