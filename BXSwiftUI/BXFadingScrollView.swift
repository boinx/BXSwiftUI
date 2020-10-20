//**********************************************************************************************************************
//
//  BXFadingScrollView.swift
//	A ScrollView that fades out clipped content at the edges
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


public struct BXFadingScrollView<Content:View> : View
{
	// Params
	
	let margin:CGFloat
	let content:()->Content
	
	// State
	
	@State private var topAlpha = 1.0
	@State private var bottomAlpha = 1.0
	
	// Init
	
	public init(margin:CGFloat = 40, @ViewBuilder content:@escaping ()->Content)
	{
		self.margin = margin
		self.content = content
	}
	
	// Build View
	
	public var body : some View
	{
		GeometryReader
		{
			outer in
			
			ScrollView
			{
				self.content()
				
					// Measure scroll position and content height
					
					.background( GeometryReader
					{
						inner in
						Color.clear.preference(key:BXFadingScrollViewKey.self, value:[inner.frame(in:.global)])
					})
			}
			
			// Apply a gradient mask to ScrollView
			
			.mask(
				self.verticalGradient()
			)
			
			// Update the gradient mask upon scrolling
			
			.onPreferenceChange(BXFadingScrollViewKey.self)
			{
				inner in
				let innerBounds = inner[0]
				let outerBounds = outer.frame(in:.global)
				self.didScroll(innerBounds,outerBounds)
             }
		}
	}

	/// Called when the user scrolled. Recalculate the top and bottom alpha levels.
	
	func didScroll(_ innerBounds:CGRect,_ outerBounds:CGRect)
	{
		let H = innerBounds.height
		let h = outerBounds.height
		let a1 = 1.0 - (innerBounds.origin.y + H-h - outerBounds.origin.y).clipped(to:0...margin) / margin
		let a2 = 1.0 - (outerBounds.origin.y - innerBounds.origin.y).clipped(to:0...margin) / margin
		
		self.topAlpha = Double(a1)
		self.bottomAlpha = Double(a2)
//		print("outerBounds=\(outerBounds)   innerBounds=\(innerBounds)    alpha1=\(alpha1)    alpha2=\(alpha2)")
	}

	/// Rebuilds the mask gradient
	
	func verticalGradient() -> some View
	{
		var colors:[Color] = []
		
		colors += Color(white:1.0, opacity:topAlpha)
		colors += [.white,.white]
		colors += Color(white:1.0, opacity:bottomAlpha)
				
		return LinearGradient(
			gradient:Gradient(colors:colors),
			startPoint:.top,
			endPoint:.bottom)
	}
	
}


//----------------------------------------------------------------------------------------------------------------------


struct BXFadingScrollViewKey: PreferenceKey
{
    typealias Value = [CGRect]

	static var defaultValue:[CGRect] = [CGRect.zero]

    static func reduce(value:inout [CGRect], nextValue:()->[CGRect])
    {
        value += nextValue()
    }
}


//----------------------------------------------------------------------------------------------------------------------
