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

	@State var size:CGSize = CGSize(width:20, height:20)
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, value:Binding<NSAttributedString>)
	{
		self.label = label
		self.width = width
		self.value = value
	}
	
	
	public var body: some View
	{
		BXLabelView(label:label, width:width, alignment:.top)
		{
			BXCustomTextView(value:self.value, size:self.$size)
//			{
//				(nstextfield,_,_) in
//				nstextfield.isBordered = true
//				nstextfield.drawsBackground = true
//			}
			.frame(minHeight:self.size.height)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

