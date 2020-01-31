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

	@State private var fittingSize:CGSize = CGSize(width:20, height:20)
//	@State var text = "Testing…\n123\n456\n789"
	
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
//			TextField("", text: self.$text)
//				.alignmentGuide(.firstTextBaseline) { _ in 16.0 }
//				.lineLimit(0)
			
			BXCustomTextView(value:self.value, fittingSize:self.$fittingSize)
//			{
//				(nstextfield,_,_) in
//				nstextfield.isBordered = true
//				nstextfield.drawsBackground = true
//			}
			.alignmentGuide(.firstTextBaseline)
			{
				_ in return 15.0
			}
			.frame(height:self.fittingSize.height)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

