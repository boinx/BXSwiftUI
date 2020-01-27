//**********************************************************************************************************************
//
//  BXIndentationView
//	A view that indents its contents similar to what Mail does for quotations
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXIndentationView<Content> : View where Content:View
{
	private var leading:CGFloat
	private var lineWidth:CGFloat
	private var lineColor:Color
	private var spacing:CGFloat
	private var content:()->Content

	public init(leading:CGFloat = 14, lineWidth:CGFloat = 2, lineColor:Color = Color(white:1.0, opacity:0.1), spacing:CGFloat = 14, @ViewBuilder content:@escaping ()->Content)
	{
		self.leading = leading
		self.lineWidth = lineWidth
		self.lineColor = lineColor
		self.spacing = spacing
		self.content = content
	}

	private var line: some View
	{
		HStack
		{
			Rectangle()
				.fill(self.lineColor)
				.frame(width:self.lineWidth)
				
			Spacer()
		}
	}
	
	
	public var body: some View
	{
		self.content()
			.padding(.leading,self.spacing+self.lineWidth)
			.background(line)
			.padding(.leading,self.leading)
	}
}


//----------------------------------------------------------------------------------------------------------------------
