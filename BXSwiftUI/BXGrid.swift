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
///
///     BXGrid(columnCount:3)
///		{
///			BXGridRow
///			{
///				BXGridCell(0)
///				{
///					...
///				}
///
///				BXGridCell(1)
///				{
///					...
///				}
///
///				BXGridCell(2)
///				{
///					...
///				}
///			}
///
///			BXGridRow
///			{
///				BXGridCell(0)
///				{
///					...
///				}
///
///				BXGridCell(1)
///				{
///					...
///				}
///
///				BXGridCell(2)
///				{
///					...
///				}
///			}
///		}

public struct BXGrid<Content> : View where Content:View
{
	// Params
	
	private var gridID:String
	private var columnCount:Int = 1
	private var spacing:CGSize
	private var content:()->Content

	// Environment

	@Environment(\.bxGridSpacing) private var bxGridSpacing

	// State
	
	@State private var columnWidths:[CGFloat] = []
	
	// Init
	
	public init(columnCount:Int, spacing:CGSize = CGSize(8,8), defaultColumnWidth:CGFloat = 120, @ViewBuilder content:@escaping ()->Content)
	{
		self.gridID = UUID().uuidString
		self.columnCount = columnCount
		self.spacing = spacing
		self.content = content
		
		self.setDefaultWidths(columnCount:columnCount, defaultColumnWidth:defaultColumnWidth)	// Separated into its own function to avoid a Swift compiler segmentation fault on Xcode 12 - do not eliminate this for now!
	}
	
	func setDefaultWidths(columnCount:Int, defaultColumnWidth:CGFloat)
	{
		self.columnWidths = [CGFloat](repeating:defaultColumnWidth, count:columnCount)
	}
	
	// Build Grid
	
	public var body : some View
	{
		VStack(alignment:.leading, spacing:spacing.height)
		{
			content()
		}
				
		// Inject grid ID and column widths
		
		.environment(\.bxGridID, self.gridID)
		.environment(\.bxGridSpacing, self.spacing)
		.environment(\.bxGridColumnWidths, self.columnWidths)
		
		// Determine columnWidths as attached preferences change
		
		.onPreferenceChange(BXGridColumnWidthKey.self)
		{
			preferences in
			
			var widths = [CGFloat](repeating:0.0, count:self.columnCount)
			
			for metadata in preferences
			{
				if metadata.gridID == self.gridID
				{
					let i = metadata.column
					let w = max(widths[i], metadata.width)
					widths[i] = w
				}
			}
			
			self.columnWidths = widths
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// A BXGridRow defines a single row in the BXGrid and should contain multiple BXGridColumns

public struct BXGridRow<Content> : View where Content:View
{
	// Params

	private var alignment:VerticalAlignment
	private var content:()->Content

	// Environment

	@Environment(\.bxGridSpacing) private var bxGridSpacing

	// Init

	public init(alignment:VerticalAlignment = .firstTextBaseline, @ViewBuilder content:@escaping ()->Content)
	{
		self.alignment = alignment
		self.content = content
	}

	// Build View

	public var body: some View
	{
		HStack(alignment:self.alignment, spacing: bxGridSpacing.width)
		{
			self.content()
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// BXGridCell defines the content of a single cell in the BXGrid. BXGridCell communicates its size to the enclosing BXGrid so that it can decide
/// how wide each columns needs to be so that no cell content get clipped.

public struct BXGridCell<Content> : View where Content:View
{
	// Params

	private var columns:ClosedRange<Int>
	private var alignment:Alignment
	private var content:()->Content

	// Environment

	@Environment(\.bxGridID) private var bxGridID
	@Environment(\.bxGridColumnWidths) private var bxGridColumnWidths
	@Environment(\.bxGridSpacing) private var bxGridSpacing

	// Init

	public init(_ column:Int, alignment:Alignment = .leading, @ViewBuilder content:@escaping ()->Content)
	{
		self.columns = column ... column
		self.alignment = alignment
		self.content = content
	}

	public init(_ columns:ClosedRange<Int>, alignment:Alignment = .leading, @ViewBuilder content:@escaping ()->Content)
	{
		self.columns = columns
		self.alignment = alignment
		self.content = content
	}

	// Build View

	public var body: some View
	{
		self.content()

			// Measure the required width for this column content

			.measureRequiredWidth(gridID:self.bxGridID, columns:self.columns)

			// Resize to column width that was calculated by the enclosing BXGrid

			.frame(width:self.columnWidth, alignment:self.alignment)
	}

	// Returns the width for the current column

	private var columnWidth:CGFloat
	{
		var width:CGFloat = 0.0
		let n = self.columns.count

		for i in self.columns
		{
			if i < bxGridColumnWidths.count
			{
				width += bxGridColumnWidths[i]
			}
			else
			{
				width += 10000
			}
		}

		if n > 1
		{
			width += CGFloat(n-1) * bxGridSpacing.width
		}

		return width
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

extension View
{
	/// Measures the required width of the content of a BXGridCell and attaches a preference with the corresponding data, so that the enclosing BXGrid can
	/// determine the column widths.
	
	func measureRequiredWidth(gridID:String, columns:ClosedRange<Int>) -> some View
	{
		guard columns.count == 1 else { return AnyView(self) }
		
		return AnyView( self.background( GeometryReader
		{
			Color.clear.preference(
				key: BXGridColumnWidthKey.self,
				value: [BXGridColumnData(gridID:gridID, column:columns.lowerBound, width:$0.size.width)])
		}))
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

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


// MARK: -

/// Injects the ID of a BXGrid into the environment

public extension EnvironmentValues
{
    var bxGridID:String
    {
        set { self[BXGridIDKey.self] = newValue }
        get { self[BXGridIDKey.self] }
    }
}

struct BXGridIDKey : EnvironmentKey
{
    static let defaultValue:String = "defaultGrid"
}


//----------------------------------------------------------------------------------------------------------------------


/// Injects the grid spacing of a BXGrid into the environment

public extension EnvironmentValues
{
    var bxGridSpacing:CGSize
    {
        set { self[BXGridSpacingKey.self] = newValue }
        get { self[BXGridSpacingKey.self] }
    }
}

struct BXGridSpacingKey : EnvironmentKey
{
    static let defaultValue:CGSize = CGSize(8,8)
}


//----------------------------------------------------------------------------------------------------------------------


/// Injects the column widths of a BXGrid into the environment

public extension EnvironmentValues
{
    var bxGridColumnWidths:[CGFloat]
    {
        set { self[BXGridColumnWidthsKey.self] = newValue }
        get { self[BXGridColumnWidthsKey.self] }
    }
}

struct BXGridColumnWidthsKey : EnvironmentKey
{
    static let defaultValue:[CGFloat] = []
}


//----------------------------------------------------------------------------------------------------------------------
