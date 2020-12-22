//**********************************************************************************************************************
//
//  BXButtonGroup.swift
//	Functionally identical to BXLabelGroup, but with a different name
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Functionally identical to BXLabelGroup, but with a different name.

public struct BXButtonGroup<Content> : View where Content:View
{
	// Params
	
	private var labelGroupID:String
	private var minWidth:CGFloat = 0.0
	private var content:()->Content

	// State
	
	@State private var labelWidth:CGFloat = 60.0
	
	// Init
	
	public init(minWidth:CGFloat = 0.0, @ViewBuilder content:@escaping ()->Content)
	{
		self.labelGroupID = UUID().uuidString
		self.minWidth = minWidth
		self.content = content
	}
	
	// Build View
	
	public var body: some View
	{
		content()
			
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
				
				self.labelWidth = maxSize.width
			}
	}

}


//----------------------------------------------------------------------------------------------------------------------
