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
	
	private var labelGroupID:String
	private var minWidth:CGFloat = 0.0
	private var spacing:CGFloat = 12.0
	private var content:()->Content

	// State
	
	@State private var labelWidth:CGFloat = 60.0
	
	// Init
	
	public init(spacing:CGFloat = 12.0, minWidth:CGFloat = 0.0, @ViewBuilder content:@escaping ()->Content)
	{
		self.labelGroupID = UUID().uuidString
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
		
		.environment(\.bxLabelGroupID, self.labelGroupID)
		
		// Inject labelWidth binding into environment so that BXLabelViews can resize themselves
		
		.environment(\.bxLabelWidth, self.$labelWidth)
		
		// Determine largest view size to decide on common label width for this group
		
		.onPreferenceChange(BXViewSizeKey.self)
		{
			preferences in
			
			var maxSize = CGSize(self.minWidth,0.0)
			
			for metadata in preferences
			{
				if metadata.groupID == self.labelGroupID
				{
					maxSize.width = max(maxSize.width, metadata.size.width)
					maxSize.height = max(maxSize.height, metadata.size.height)
				}
			}

			self.labelWidth = ceil(maxSize.width)
		}
	}

}


//----------------------------------------------------------------------------------------------------------------------


/// Creates a button with equal width when inside a BXButtonGroup

public struct BXEqualWidthButton : View
{
	// Params
	
	private let title:String
	private let action:()->Void
	
	// Environment
	
	@Environment(\.bxLabelGroupID) private var bxLabelGroupID
	@Environment(\.bxLabelWidth) private var bxLabelWidth

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
				.measureViewSize(forGroupID:self.bxLabelGroupID)
				.frame(width:self.bxLabelWidth.wrappedValue)
		}
	}
}


/// Creates a button with equal width when inside a BXButtonGroup

public struct BXEqualWidthGenericButton<Content:View> : View
{
	// Params
	
	private let action:()->Void
	private let content:(()->Content)?
	
	// Environment
	
	@Environment(\.bxLabelGroupID) private var bxLabelGroupID
	@Environment(\.bxLabelWidth) private var bxLabelWidth

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
				.measureViewSize(forGroupID:self.bxLabelGroupID)
				.frame(width:self.bxLabelWidth.wrappedValue)
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------
