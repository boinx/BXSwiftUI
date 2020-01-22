//**********************************************************************************************************************
//
//  BXDisclosureViewswift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXDisclosureView<H,B> : View where H:View, B:View
{
	private var isExpanded:Binding<Bool>
	private var headerBuilder:()->H
	private var bodyBuilder:()->B

	public init(isExpanded:Binding<Bool>, @ViewBuilder header headerBuilder:@escaping ()->H, @ViewBuilder body bodyBuilder:@escaping ()->B)
	{
		self.isExpanded = isExpanded
		self.headerBuilder = headerBuilder
		self.bodyBuilder = bodyBuilder
	}

	public var body: some View
	{
		VStack(alignment:.leading, spacing:12)
		{
			headerBuilder()

			if isExpanded.wrappedValue
			{
				bodyBuilder()
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXDisclosureButton : View
{
	private var label:String
	private var isExpanded:Binding<Bool>
	
	public init(_ label:String, isExpanded:Binding<Bool>)
	{
		self.label = label
		self.isExpanded = isExpanded
	}
	
	public var body: some View
	{
		HStack(spacing:4.0)
		{
			Text("▶︎")
				.font(.subheadline)
				.rotationEffect(.degrees(isExpanded.wrappedValue ? 90 : 0))
				
			Text(label)
				.font(.headline)
		}
		
		.onTapGesture
		{
			withAnimation(.easeInOut(duration:0.15))
			{
				self.isExpanded.wrappedValue.toggle()
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
