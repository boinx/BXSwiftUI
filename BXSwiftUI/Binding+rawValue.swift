//**********************************************************************************************************************
//
//  Binding+Optional.swift
//	Creates a non-optional Binding to an optional property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension Binding
{
	/// Creates a Binding to a rawValue for an existing Binding. That way semantically rich types likes enums
	/// can be used in data models, while the UI can use rawValues like Ints.
	/// - parameter binding: A Binding to a RawRepresentable type (e.g. an Int enum)
	/// - returns: A Binding to the rawValue of the original type (e.g. Int)

	static func rawValue<T:RawRepresentable>(for binding:Binding<T>) -> Binding<T.RawValue>
	{
		return Binding<T.RawValue>(
		
			get:
			{
				binding.wrappedValue.rawValue
			},
			
			set:
			{
				guard let value = T.init(rawValue:$0) else { return }
				binding.wrappedValue = value
			})
	}
}


//----------------------------------------------------------------------------------------------------------------------

