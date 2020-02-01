//**********************************************************************************************************************
//
//  BXStringEditView.swift
//	A view to edit a single String property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXStringEditView : View
{
	private var label:String = ""
	private var width:Binding<CGFloat>? = nil
	private var value:Binding<String>


	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<String>)
	{
		self.label = label
		self.width = width
		self.value = value
	}
	
	
	public var body: some View
	{
		BXLabelView(label:label, width:width)
		{
			BXTextField(value:self.value, height:21)
				.alignmentGuide(.firstTextBaseline, computeValue:{ _ in 15.0 })
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

