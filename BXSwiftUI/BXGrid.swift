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
		VStack(alignment:.leading)
		{
			content()
		}
				
		// Inject grid ID and column widths
		
		.environment(\.bxGridID, self.gridID)
		.environment(\.bxGridColumnWidths, self.$columnWidths)
		
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

public struct BXGridColumn<Content> : View where Content:View
{
	// Params
	
	private var columns:[Int]
	private var alignment:Alignment
	private var spacing:CGFloat
	private var content:()->Content

	// Environment
	
	@Environment(\.bxGridID) private var bxGridID
	@Environment(\.bxGridColumnWidths) private var bxGridColumnWidths

	// Init
	
	public init(_ column:Int, alignment:Alignment = .leading, spacing:CGFloat = 8, @ViewBuilder content:@escaping ()->Content)
	{
		self.columns = [column]
		self.alignment = alignment
		self.spacing = spacing
		self.content = content
	}
	
	public init(_ columns:[Int], alignment:Alignment = .leading, spacing:CGFloat = 8, @ViewBuilder content:@escaping ()->Content)
	{
		self.columns = columns
		self.alignment = alignment
		self.spacing = spacing
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
			if i < bxGridColumnWidths.wrappedValue.count
			{
				width += bxGridColumnWidths.wrappedValue[i]
			}
			else
			{
				width += 10000
			}
		}
		
		if n > 1
		{
			width += CGFloat(n-1) * spacing
		}

		return width
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

extension View
{
	/// Measures the required width of the receiving view and attaches a preference with the corresponding data, so that the enclosing BXGrid can
	/// determine the column widths.
	
	func measureRequiredWidth(gridID:String, columns:[Int]) -> some View
	{
		guard columns.count == 1 else { return AnyView(self) }
		
		return AnyView( self.background( GeometryReader
		{
			Color.clear.preference(
				key: BXGridColumnWidthKey.self,
				value: [BXGridColumnData(gridID:gridID, column:columns[0], width:$0.size.width)])
		}))
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
