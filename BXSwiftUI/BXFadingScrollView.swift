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
	
	let axis:Axis.Set
	let margin:CGFloat
	let content:()->Content
	
	// State
	
	@State private var alpha1 = 1.0
	@State private var alpha2 = 1.0
	
	// Init
	
	public init(_ axis:Axis.Set = .vertical, margin:CGFloat = 30, @ViewBuilder content:@escaping ()->Content)
	{
		self.axis = axis
		self.margin = margin
		self.content = content
	}
	
	// Build View
	
	public var body : some View
	{
		GeometryReader
		{
			outer in
			
			ScrollView(self.axis)
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
				self.gradient()
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
		if axis == .vertical
		{
			let H = innerBounds.height
			let h = outerBounds.height
			
			let A1 = 1.0 - (innerBounds.origin.y + H-h - outerBounds.origin.y).clipped(to:0...margin) / margin
			let A2 = 1.0 - (outerBounds.origin.y - innerBounds.origin.y).clipped(to:0...margin) / margin
			let isRunningOnMonterey = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 12
			
			let a1 = isRunningOnMonterey ? A2 : A1
			let a2 = isRunningOnMonterey ? A1 : A2
			
			self.alpha1 = Double(a1)
			self.alpha2 = Double(a2)
		}
		else
		{
			let W = innerBounds.width
			let w = outerBounds.width

			let a1 = 1.0 - (outerBounds.origin.x - innerBounds.origin.x).clipped(to:0...margin) / margin
			let a2 = 1.0 - (innerBounds.origin.x - outerBounds.origin.x + W-w).clipped(to:0...margin) / margin
			
			self.alpha1 = Double(a1)
			self.alpha2 = Double(a2)
		}
		
//		print("outerBounds=\(outerBounds)   innerBounds=\(innerBounds)    alpha1=\(alpha1)    alpha2=\(alpha2)")
	}

	/// Rebuilds the mask gradient
	
	func gradient() -> some View
	{
		var colors:[Color] = []
		
		colors += Color(white:1.0, opacity:alpha1)
		colors += [.white,.white]
		colors += Color(white:1.0, opacity:alpha2)
		
		if axis == .vertical
		{
			return LinearGradient(
				gradient:Gradient(colors:colors),
				startPoint:.top,
				endPoint:.bottom)
		}
		else
		{
			return LinearGradient(
				gradient:Gradient(colors:colors),
				startPoint:.leading,
				endPoint:.trailing)
		}
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
