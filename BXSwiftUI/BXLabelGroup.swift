//**********************************************************************************************************************
//
//  BXLabelView.swift
//	BXLabelViews communicate with each other and decide on a common maximum width for localization purposes
//  Copyright ©2020-2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// All BXLabelViews within a BXLabelGroup get a common width assigned to them. This helps with localization,
/// as the widest label string determines how wide all BXLabelViews will be. That way nothing gets clipped.

public struct BXLabelGroup<Content> : View where Content:View
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
			
			.onPreferenceChange(BXLabelSizeKey.self)
			{
				preferences in
				
				print("BXLabelGroup.onPreferenceChange")
		
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


// MARK: -

public extension EnvironmentValues
{
    var bxLabelGroupID:String
    {
        set { self[BXLabelGroupIDKey.self] = newValue }
        get { return self[BXLabelGroupIDKey.self] }
    }
}

struct BXLabelGroupIDKey : EnvironmentKey
{
    static let defaultValue:String = "defaultGroup"
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public extension EnvironmentValues
{
    var bxLabelWidth:Binding<CGFloat>
    {
        set { self[BXLabelWidthKey.self] = newValue }
        get { return self[BXLabelWidthKey.self] }
    }
}

struct BXLabelWidthKey : EnvironmentKey
{
    static let defaultValue:Binding<CGFloat> = Binding.constant(60.0)
}


//----------------------------------------------------------------------------------------------------------------------
