//**********************************************************************************************************************
//
//  BXGrid.swift
//	BXGrid provides a 2D grid layout with automatic column sizing
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


/// BXGrid generates a tableview-like layout with aligned columns. Columns are automatically resized to make sure that no content gets clipped,
/// which helps with localization. Defining a BXGrid looks similar to a HTML table.


public struct BXPageLayout<Content> : View where Content:View
{
	// Params
	
	private var pageSize:CGSize
	private var content:()->Content

	// Init
	
	public init(pageSize:CGSize, @ViewBuilder content:@escaping ()->Content)
	{
		self.pageSize = pageSize
		self.content = content
	}
	
	// Build View
	
	public var body : some View
	{
		self.content()
			.coordinateSpace(name:"BXPageLayout")
			.environment(\.bxPageSize, self.pageSize)
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// BXGridCell defines the content of a single cell in the BXGrid. BXGridCell communicates its size to the enclosing BXGrid so that it can decide
/// how wide each columns needs to be so that no cell content get clipped.

public struct BXPageCell<Content> : View where Content:View
{
	// Params

	private var content:()->Content
	
	@State private var dy:CGFloat = 0.0
	
	// Environment

	@Environment(\.bxPageSize) private var bxPageSize

	// Init

	public init(@ViewBuilder content:@escaping ()->Content)
	{
		self.content = content
	}

	// Build View

	public var body: some View
	{
		self.content()
		
			.background( GeometryReader
			{
				proxy in
				
				Color.clear.onAppear
				{
					let frame = proxy.frame(in:.named("BXPageLayout"))
					self.dy = self.topPadding(for:frame)
				}
			})
			
			.padding(.top, dy)
	}


	/// Returns the top padding that is necessary to make sure that a View doesn't overlap a page break
	
	func topPadding(for frame:CGRect) -> CGFloat
	{
		let top = frame.minY
		let bottom = frame.maxY
		let height = self.bxPageSize.height
		let topPageIndex = Int(top / height)
		let bottomPageIndex = Int(bottom / height)

		// If the top and the bottom of the cell frame are on the same page, then we do not
		// need to add any padding, so return 0.0
		
		var dy = 0.0
		
		// Otherwise return the distance from the top of the frame to the next page break
		
		if topPageIndex < bottomPageIndex
		{
			let pageBreak = height * CGFloat(bottomPageIndex)
			dy = pageBreak - top
		}
		
Swift.print("BXPageCell.topPadding()   bxPageSize=\(bxPageSize)   frame=\(frame)   dy=\(dy)")

		return dy
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// Injects page size into the environment

public extension EnvironmentValues
{
    var bxPageSize:CGSize
    {
        set { self[BXPageSizeKey.self] = newValue }
        get { self[BXPageSizeKey.self] }
    }
}

struct BXPageSizeKey : EnvironmentKey
{
    static let defaultValue:CGSize = CGSize(8.5*72.0, 11*72.0)
}


//----------------------------------------------------------------------------------------------------------------------
