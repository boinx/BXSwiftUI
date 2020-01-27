//**********************************************************************************************************************
//
//  BXBoolEditView.swift
//	A view to edit a single Bool property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXBoolEditView : View
{
	private var label:String
	private var width:Binding<CGFloat>? = nil
	private var value:Binding<Bool>


	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<Bool>)
	{
		self.label = label
		self.width = width
		self.value = value
	}
	
	
	public var body: some View
	{
		BXLabelView(label:label, width:width)
		{
			Toggle("", isOn:self.value).labelsHidden()
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

