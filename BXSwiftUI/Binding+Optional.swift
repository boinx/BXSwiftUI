//**********************************************************************************************************************
//
//  Formatter+Custom.swift
//	Various custom formatters
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


extension Binding
{
	/// Creates a non-optional Binding to an optional property T? of an object.
	/// - parameter object: The object that contains the optional property
	/// - parameter keyPath: The keypath to the optional property
	/// - parameter defaultValue: The value to be used if the property is nil
	/// - returns: A non-optional Binding of type T

	public init<T:AnyObject>(object:T, keyPath:ReferenceWritableKeyPath<T,Value?>, defaultValue:Value)
	{
		self.init(
			get:
			{
				object[keyPath:keyPath] ?? defaultValue
			},
			set:
			{
				object[keyPath:keyPath] = $0
			}
		)
	}
}


//----------------------------------------------------------------------------------------------------------------------

