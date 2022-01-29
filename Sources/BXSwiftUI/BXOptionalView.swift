//**********************************************************************************************************************
//
//  BXOptionalView.swift
//	Builds the supplied view if an optional value is non-nil
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// SwiftUI is pretty particular when it comes to using optionals, because @ObservedObject cannot be used on
/// optional datatypes. It can only be used on classes that adopt the ObservableObject protocol. In addition
/// you cannot use the full Swift syntax toolbox inside the body function. BXOptionalView helps you with this
/// problem by wrapping an optional type. If it can be unwrapped, it passes the unwrapped type to the content
/// closure, otherwise it just displays Text("nil").

public struct BXOptionalView<M,V> : View where V:View
{
	private var value:M?
	private var content:(M)->V
	private var displaysNil = true
	
	public init(value:M?, displaysNil:Bool = true, @ViewBuilder content:@escaping (M)->V)
	{
		self.value = value
		self.displaysNil = displaysNil
		self.content = content
	}
	
	public var body: some View
	{
		Group
		{
			// Unwrap - if available then use content
			
			if self.value != nil
			{
				self.content(self.value!)
			}
			
			// Otherwise just display "nil"
			
			else if displaysNil
			{
				Text("nil")
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

