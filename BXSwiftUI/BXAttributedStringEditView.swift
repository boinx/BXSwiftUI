//**********************************************************************************************************************
//
//  BXAttributedStringEditView.swift
//	A view to edit a single NSAttributedString property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXAttributedStringEditView : View
{
	private var label:String = ""
	private var width:Binding<CGFloat>? = nil
	private var value:Binding<NSAttributedString>

	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<NSAttributedString>)
	{
		self.label = label
		self.width = width
		self.value = value
	}
	
	public var body: some View
	{
		BXLabelView(label:label, width:width)
		{
			BXTextView(value:self.value)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

