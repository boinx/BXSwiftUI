//**********************************************************************************************************************
//
//  BXOptionalView.swift
//	Builds the supplied view if an optional value is non-nil
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXOptionalView<M,V> : View where V:View
{
	private var value:M?
	private var content:(M)->V

	public init(value:M?, @ViewBuilder content:@escaping (M)->V)
	{
		self.value = value
		self.content = content
	}
	
	public var body: some View
	{
		Group
		{
			if self.value != nil
			{
				self.content(self.value!)
			}
			else
			{
				Text("nil")
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

