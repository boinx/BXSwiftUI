//**********************************************************************************************************************
//
//  BXDisclosureView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXDisclosureView<H,B> : View where H:View, B:View
{
	// Params
	
	private var isExpanded:Binding<Bool>
	private var spacing:CGFloat
	private var headerBuilder:()->H
	private var bodyBuilder:()->B

	// Environment
	
	@Environment(\.isEnabled) private var isEnabled

	// Init
	
	public init(isExpanded:Binding<Bool>, spacing:CGFloat = 12, @ViewBuilder header headerBuilder:@escaping ()->H, @ViewBuilder body bodyBuilder:@escaping ()->B)
	{
		self.isExpanded = isExpanded
		self.spacing = spacing
		self.headerBuilder = headerBuilder
		self.bodyBuilder = bodyBuilder
	}

	// Build View
	
	public var body: some View
	{
		VStack(alignment:.leading, spacing:spacing)
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
	// Params
	
	private var label:String
	private var isExpanded:Binding<Bool>

	// Environment
	
	@Environment(\.font) var font

	// Init
	
	public init(_ label:String, isExpanded:Binding<Bool>)
	{
		self.label = label
		self.isExpanded = isExpanded
	}
	
	// Build View
	
	public var body: some View
	{
		HStack(spacing:2.0)
		{
			// Disclosure triangle
			
			Text("▶︎")
				.font(font)
				.scaleEffect(0.85)
				.rotationEffect(.degrees(isExpanded.wrappedValue ? 90 : 0))
				
				// Provide a bigger hit target for clicking the triangle
				
				.overlay(
					GeometryReader
					{
						Rectangle()
							.fill(Color(white:0.0, opacity:0.01))
							.offset(x:-5, y:-5)
							.frame(width:$0.size.width+10, height:$0.size.height+14)
					}
				)

			// Label
			
			if label.count > 0
			{
				Text(label).font(font)
			}
		}
		
		// Dim when disabled
		
		.reducedOpacityWhenDisabled()
		
		// On tap toggle the disclosure state
		
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
