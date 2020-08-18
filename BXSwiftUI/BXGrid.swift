//**********************************************************************************************************************
//
//  BXGrid.swift
//	BXGrid provides a 2D grid with automatic column sizing
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// All BXLabelViews within a BXLabelGroup get a common width assigned to them. This helps with localization,
/// as the widest label string determines how wide all BXLabelViews will be. That way nothing gets clipped.

public struct BXGrid<Content> : View where Content:View
{
	// Params
	
	private var gridID:String
	private var columnCount:Int = 1
	private var content:()->Content

	// State
	
	@State private var columnWidths = Array<CGFloat>()
	
	// Init
	
	public init(columnCount:Int, defaultColumnWidth:CGFloat = 120, @ViewBuilder content:@escaping ()->Content)
	{
		self.gridID = UUID().uuidString
		self.columnCount = columnCount
		self.content = content
		
		self.columnWidths = [CGFloat](repeating:defaultColumnWidth, count:columnCount)
	}
	
	// Build Grid
	
	public var body : some View
	{
		content()
			
			// Inject grid ID and column widths
			
			.environment(\.bxGridID, self.gridID)
			.environment(\.bxGridColumnWidths, self.$columnWidths)
			
			// Determine columnWidths as attached preferences change
			
			.onPreferenceChange(BXGridColumnWidthKey.self)
			{
				preferences in
				
				print("\nFind new column widths")
				
				var widths = [CGFloat](repeating:0.0, count:self.columnCount)
				
				for metadata in preferences
				{
					if metadata.gridID == self.gridID
					{
						let i = metadata.column
						let w = max(widths[i], metadata.width)
						widths[i] = w
						print("column \(i) width = \(w)")
					}
				}
				
				print("Column widths = \(widths)\n")
				self.columnWidths = widths
			}
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public struct BXGridColumn<Content> : View where Content:View
{
	// Params
	
	private var column:Int
	private var alignment:Alignment
	private var content:()->Content

	// Environment
	
	@Environment(\.bxGridID) private var bxGridID
	@Environment(\.bxGridColumnWidths) private var bxGridColumnWidths

	// Init
	
	public init(_ column:Int, alignment:Alignment = .leading, @ViewBuilder content:@escaping ()->Content)
	{
		self.column = column
		self.alignment = alignment
		self.content = content
	}
	
	// Build View
	
	public var body: some View
	{
		self.content()
		
			// Measure the required width for this column content
			
			.background( GeometryReader
			{
				Color.clear.preference(
					key: BXGridColumnWidthKey.self,
					value: [BXGridColumnData(gridID:self.bxGridID, column:self.column, width:self.requiredWidth(for:$0))])
			})

			// Resize to common column width
			
			.frame(width:self.columnWidth, alignment:self.alignment)
	}
	
	private func requiredWidth(for geometry:GeometryProxy) -> CGFloat
	{
		let width = geometry.size.width
		print("Measure column content width = \(width)")
		return width
	}
	
	private var columnWidth:CGFloat
	{
		let i = self.column
		guard i < bxGridColumnWidths.wrappedValue.count else { return 1000.0 }
		return bxGridColumnWidths.wrappedValue[i]
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public extension EnvironmentValues
{
    var bxGridID:String
    {
        set
        {
            self[BXGridIDKey.self] = newValue
        }

        get
        {
            return self[BXGridIDKey.self]
        }
    }
}

struct BXGridIDKey : EnvironmentKey
{
    static let defaultValue:String = "defaultGrid"
}


//----------------------------------------------------------------------------------------------------------------------


public extension EnvironmentValues
{
    var bxGridColumnWidths:Binding<[CGFloat]>
    {
        set
        {
            self[BXGridColumnWidthsKey.self] = newValue
        }

        get
        {
            return self[BXGridColumnWidthsKey.self]
        }
    }
}

struct BXGridColumnWidthsKey : EnvironmentKey
{
    static let defaultValue:Binding<[CGFloat]> = Binding.constant([100,100,100,100,100,100,100,100,100,100,100])
}


//----------------------------------------------------------------------------------------------------------------------


/// The key needed to attach size data to a View

struct BXGridColumnWidthKey : PreferenceKey
{
	typealias Value = [BXGridColumnData]

	static var defaultValue:[BXGridColumnData] = []

    static func reduce(value:inout [BXGridColumnData], nextValue:()->[BXGridColumnData])
    {
		value.append(contentsOf: nextValue())
    }
}

/// The attached data contains the size and a groupID to filter out unwanted candidates when deciding on a common label width

struct BXGridColumnData : Equatable
{
	let gridID:String
	let column:Int
    let width:CGFloat
}


//----------------------------------------------------------------------------------------------------------------------
