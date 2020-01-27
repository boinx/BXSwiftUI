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
	private var label:String
	private var width:Binding<CGFloat>? = nil
	private var value:Binding<URL>


	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<URL>)
	{
		self.label = label
		self.width = width
		self.value = value
	}
	
	
	public var body: some View
	{
		BXLabelView(label:label, width:width)
		{
			BXCustomTextField(value:self.value)
			{
				(nstextfield,_,_) in
				nstextfield.isBordered = true
				nstextfield.drawsBackground = true
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

