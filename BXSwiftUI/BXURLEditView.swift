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
	private var labelWidth:Binding<CGFloat>? = nil
	private var value:Binding<URL>

	public init(label:String, labelWidth:Binding<CGFloat>? = nil, value:Binding<URL>)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
	}
	
	public var body: some View
	{
		HStack
		{
			BXPropertyLabel(label, width:labelWidth)

			BXCustomTextField(value:value)
			{
				(nstextfield,_,_) in
				nstextfield.isBordered = true
				nstextfield.drawsBackground = true
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
