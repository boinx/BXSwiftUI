//**********************************************************************************************************************
//
//  BXURLEditViewswift
//	A view to edit a single URL property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXURLEditView : View
{
	// Params
	
	private var label:String
	private var value:Binding<URL>

	// Init
	
	public init(label:String = "", value:Binding<URL>)
	{
		self.label = label
		self.value = value
	}
	
	// Build View
	
	public var body: some View
	{
		BXLabelView(label:label, alignment:.leading)
		{
			BXTextField(value:self.value, height:21)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

