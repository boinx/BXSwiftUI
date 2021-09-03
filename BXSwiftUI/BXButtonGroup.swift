//**********************************************************************************************************************
//
//  BXButtonGroup.swift
//	A horizontal group of buttons that are of equal width
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// A horizontal group of buttons that are of equal width

public struct BXButtonGroup<Content> : View where Content:View
{
	// Params
	
	private var buttonGroupID:String
	private var minWidth:CGFloat = 0.0
	private var spacing:CGFloat = 12.0
	private var content:()->Content

	// State
	
	@State private var buttonWidth:CGFloat = 60.0
	
	// Init
	
	public init(spacing:CGFloat = 12.0, minWidth:CGFloat = 0.0, @ViewBuilder content:@escaping ()->Content)
	{
		self.buttonGroupID = UUID().uuidString
		self.spacing = spacing
		self.minWidth = minWidth
		self.content = content
	}
	
	// Build View
	
	public var body: some View
	{
		HStack(spacing:spacing)
		{
			content()
		}
		
		// Inject group ID into environment so that child BXLabelViews know how to add preference data
		
		.environment(\.bxButtonGroupID, self.buttonGroupID)
		
		// Inject labelWidth binding into environment so that BXLabelViews can resize themselves
		
		.environment(\.bxButtonWidth, self.$buttonWidth)
		
		// Determine largest view size to decide on common label width for this group
		
		.onPreferenceChange(BXButtonSizeKey.self)
		{
			preferences in
			
			var maxSize = CGSize(self.minWidth,0.0)
			
			for metadata in preferences
			{
				if metadata.groupID == self.buttonGroupID
				{
					maxSize.width = max(maxSize.width, metadata.size.width)
					maxSize.height = max(maxSize.height, metadata.size.height)
				}
			}

			self.buttonWidth = ceil(maxSize.width)
		}
	}

}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// Creates a button with equal width when inside a BXButtonGroup

public struct BXEqualWidthButton : View
{
	// Params
	
	private let title:String
	private let action:()->Void
	
	// Environment
	
	@Environment(\.bxButtonGroupID) private var bxButtonGroupID
	@Environment(\.bxButtonWidth) private var bxButtonWidth

	// Init
	
	public init(title:String, action:@escaping ()->Void)
	{
		self.title = title
		self.action = action
	}
	
	// Build View
	
	public var body: some View
	{
		Button(action:self.action)
		{
			Text(title)
				.lineLimit(1)
				.fixedSize()
				.measureButtonSize(forGroupID:self.bxButtonGroupID)
				.frame(width:self.bxButtonWidth.wrappedValue)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// Creates a button with equal width when inside a BXButtonGroup

public struct BXEqualWidthGenericButton<Content:View> : View
{
	// Params
	
	private let action:()->Void
	private let content:(()->Content)?
	
	// Environment
	
	@Environment(\.bxButtonGroupID) private var bxButtonGroupID
	@Environment(\.bxButtonWidth) private var bxButtonWidth

	// Init
	
	public init(action:@escaping ()->Void, @ViewBuilder content:@escaping ()->Content)
	{
		self.action = action
		self.content = content
	}
	
	// Build View
	
	public var body: some View
	{
		Button(action:self.action)
		{
			self.content!()
				.fixedSize()
				.measureButtonSize(forGroupID:self.bxButtonGroupID)
				.frame(width:self.bxButtonWidth.wrappedValue)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public extension View
{
	// Measures the size of a View and attaches a preference (with its size)
	
	func measureButtonSize(forGroupID groupID:String) -> some View
	{
		self.background( GeometryReader
		{
			Color.clear.preference(
				key: BXButtonSizeKey.self,
				value: [BXButtonSizeData(groupID:groupID, size:$0.size)])
		})
	}
	
	/// Resizes the view to the width of a particular group.
	
	func resizeButton(to width:Binding<CGFloat>, for groupID:String, alignment:Alignment = .leading) -> some View
	{
		self
		
			// Measure the label size and attach a preference (metadata)
			
			.measureButtonSize(forGroupID:groupID)

			// Resize the label to the decided upon common width
			
			.frame(minWidth:width.wrappedValue, alignment:alignment)
	}
}


//----------------------------------------------------------------------------------------------------------------------


/// The key needed to attach size data to a View

struct BXButtonSizeKey : PreferenceKey
{
	typealias Value = [BXButtonSizeData]

	static var defaultValue:[BXButtonSizeData] = []

    static func reduce(value:inout [BXButtonSizeData], nextValue:()->[BXButtonSizeData])
    {
		value.append(contentsOf: nextValue())
    }
}

/// The attached data contains the size and a groupID to filter out unwanted candidates when deciding on a common label width

struct BXButtonSizeData : Equatable
{
	let groupID:String
    let size:CGSize
}


//----------------------------------------------------------------------------------------------------------------------


public extension EnvironmentValues
{
    var bxButtonGroupID:String
    {
        set { self[BXButtonGroupIDKey.self] = newValue }
        get { return self[BXButtonGroupIDKey.self] }
    }
}

struct BXButtonGroupIDKey : EnvironmentKey
{
    static let defaultValue:String = "defaultGroup"
}


//----------------------------------------------------------------------------------------------------------------------


public extension EnvironmentValues
{
    var bxButtonWidth:Binding<CGFloat>
    {
        set { self[BXButtonWidthKey.self] = newValue }
        get { return self[BXButtonWidthKey.self] }
    }
}

struct BXButtonWidthKey : EnvironmentKey
{
    static let defaultValue:Binding<CGFloat> = Binding.constant(60.0)
}


//----------------------------------------------------------------------------------------------------------------------
