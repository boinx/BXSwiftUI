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

