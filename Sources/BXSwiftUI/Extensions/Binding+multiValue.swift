//**********************************************************************************************************************
//
//  Binding+multiValue.swift
//	Creates a multiValue Binding for an existing Binding
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension Binding
{
	/// Creates a multiValue Binding for an existing Binding.

	static func multiValue<T:Hashable>(for binding:Binding<T>) -> Binding<Set<T>>
	{
		return Binding<Set<T>>(
		
			get:
			{
				Set([binding.wrappedValue])
			},
			
			set:
			{
				guard let value = $0.first else { return }
				binding.wrappedValue = value
			})
	}
}


//----------------------------------------------------------------------------------------------------------------------

