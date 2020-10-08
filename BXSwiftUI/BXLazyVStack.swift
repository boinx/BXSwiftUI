//**********************************************************************************************************************
//
//  BXGrid.swift
//	BXGrid provides a 2D grid layout with automatic column sizing
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// BXLazyVStack is similar to VStack but instead of creating ALL children at once it only creates those that are currently visible. Children that are not visible
/// due to being scrolled out of sight will be represented by a Spacer of specified size to make sure that the enclosing ScrollView still behaves correctly.
///
///     BXLazyVStack
///		{
///			ForEach(...)
///			{
///				SomeView()
///					.lazy(height:20)
///			}
///		}

public struct BXLazyVStack<Content:View> : View
{
	// Params
	
	private var alignment: HorizontalAlignment
	private var spacing: CGFloat?
	private var content:()->Content

	// Init
	
	public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content:@escaping ()->Content)
	{
		self.alignment = alignment
		self.spacing = spacing
		self.content = content
	}
	
	// Build VStack
	
	public var body : some View
	{
		BXEnclosingScrollViewProxy
		{
			visibleRect in

			VStack(alignment:self.alignment, spacing:self.spacing)
			{
				self.content()
			}
			.environment(\.bxVisibleRect, visibleRect)
		}
		.background(
			
			GeometryReader
			{
				Color.clear.environment(\.bxReferenceRect, self.referenceRect(for:$0))
			}
		)
		.coordinateSpace(name:"BXLazyVStack")
	}

	private func referenceRect(for geometry:GeometryProxy) -> CGRect
	{
		let rect = geometry.frame(in:.local)
		return rect
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// BXLazyCell wraps its content and replaces it with a Spacer of specified size if its is currently being scrolled out of sight.

public struct BXLazyCell<Content:View> : View
{
	// Params
	
	private var width:CGFloat? = nil
	private var height:CGFloat? = nil
	private var content:()->Content

	// Environment
	
	@Environment(\.bxVisibleRect) private var bxVisibleRect
	@Environment(\.bxReferenceRect) private var bxReferenceRect

	// Init
	
	public init(width:CGFloat? = nil, height:CGFloat? = nil, @ViewBuilder content:@escaping ()->Content)
	{
		self.width = width
		self.height = height
		self.content = content
	}
	
	// Build View
	
	public var body: some View
	{
		GeometryReader
		{
			geometry in
			
			Group
			{
				if self.isVisible(geometry)
				{
					self.content()
				}
				else
				{
					Spacer().frame(width:self.width, height:self.height)
				}
			}
		}
	}
	
	/// Returns true if this cell is currently visible
	
	private func isVisible(_ geometry:GeometryProxy) -> Bool
	{
		let rect = geometry.frame(in:.named("BXLazyVStack")).offsetBy(dx:0, dy:1210)
		let isVisible = NSIntersectsRect(rect,bxVisibleRect)
		print("BXLazyCell.isVisible = \(isVisible)   rect=\(rect)    bxVisibleRect=\(bxVisibleRect)     bxReferenceRect=\(bxReferenceRect)")
		return isVisible
	}
}


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Convenience modifier to warp a View in a BXLazyCell
	
	func lazy(width:CGFloat? = nil, height:CGFloat? = nil) -> some View
	{
		BXLazyCell(width:width, height:height)
		{
			self
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


/// Injects the visibleRect into the environment

public extension EnvironmentValues
{
    var bxVisibleRect:CGRect
    {
        set { self[BXVisibleRectKey.self] = newValue }
        get { self[BXVisibleRectKey.self] }
    }
}

struct BXVisibleRectKey : EnvironmentKey
{
    static let defaultValue:CGRect = .zero
}


/// Injects the visibleRect into the environment

public extension EnvironmentValues
{
    var bxReferenceRect:CGRect
    {
        set { self[BXReferenceRectKey.self] = newValue }
        get { self[BXReferenceRectKey.self] }
    }
}

struct BXReferenceRectKey : EnvironmentKey
{
    static let defaultValue:CGRect = .zero
}


//----------------------------------------------------------------------------------------------------------------------
