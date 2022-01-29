//**********************************************************************************************************************
//
//  Binding+Convert.swift
//	Converts the datatype of existing Bindings
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension Binding
{
	func convertToDoubleSet() -> Binding<Set<Double>>
	{
		return Binding<Set<Double>>(
		
			get:
			{
				guard let intValues = self.wrappedValue as? Set<Int> else { return Set() }
				let doubleValues = intValues.compactMap { Double($0) }
				return Set(doubleValues)
			},
			
			set:
			{
				let doubleValues = $0
				let intValues = doubleValues.compactMap { Int($0) }
				guard let value = Set(intValues) as? Value else { return }
				self.wrappedValue = value
			})
	}
	
	
	func convertToBoolSet() -> Binding<Set<Bool>>
	{
		return Binding<Set<Bool>>(
		
			get:
			{
				guard let intValues = self.wrappedValue as? Set<Int> else { return Set() }
				let boolValues = intValues.map { $0 != 0 }
				return Set(boolValues)
			},
			
			set:
			{
				let boolValues = $0
				let intValues = boolValues.compactMap { $0 ? 1:0 }
				guard let value = Set(intValues) as? Value else { return }
				self.wrappedValue = value
			})
	}
}


//----------------------------------------------------------------------------------------------------------------------

