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
	
	public init(_ axis:Axis.Set = .vertical, margin:CGFloat = 50, @ViewBuilder content:@escaping ()->Content)
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
				self.gradient(with:outer)
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
			
			// Calculate the alpha values for the top and bottom of the ScrollView depending on the
			// outerBounds and innerBounds of the ScrollView.
			
			let A1 = 1.0 - (innerBounds.origin.y + H-h - outerBounds.origin.y).clipped(to:0...margin) / margin
			let A2 = 1.0 - (outerBounds.origin.y - innerBounds.origin.y).clipped(to:0...margin) / margin
			
			/// WORKAROUND: For some reason the behavior of innerBounds was changed on macOS 12 Monterey.
			/// Different CGRect values are returned of origin.y, so we need to swap the calculated alpha
			/// values to get the expected results again
			
			#if os(macOS)
			let isRunningOnMonterey = ProcessInfo.isRunningOnMontereyOrNewer
			let a1 = isRunningOnMonterey ? A2 : A1
			let a2 = isRunningOnMonterey ? A1 : A2
			#else
			let a1 = A1
			let a2 = A2
			#endif
			
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
	
	func gradient(with geometry:GeometryProxy) -> some View
	{
		var colors:[Gradient.Stop] = []
		
		if axis == .vertical
		{
			let h = geometry.size.height
			let dy = min(0.49*h, margin/h)
			
			colors += Gradient.Stop(color:Color(white:1.0, opacity:alpha1), location:0.0)
			colors += Gradient.Stop(color:Color(white:1.0, opacity:1.0), 	location:0.0+dy)
			colors += Gradient.Stop(color:Color(white:1.0, opacity:1.0), 	location:1.0-dy)
			colors += Gradient.Stop(color:Color(white:1.0, opacity:alpha2), location:1.0)

			return LinearGradient(
				stops:colors,
				startPoint:.top,
				endPoint:.bottom)
		}
		else
		{
			let w = geometry.size.width
			let dx = min(0.49*w, margin/w)
			
			colors += Gradient.Stop(color:Color(white:1.0, opacity:alpha1), location:0.0)
			colors += Gradient.Stop(color:.white, location:0.0+dx)
			colors += Gradient.Stop(color:.white, location:1.0-dx)
			colors += Gradient.Stop(color:Color(white:1.0, opacity:alpha2), location:1.0)

			return LinearGradient(
				stops:colors,
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
