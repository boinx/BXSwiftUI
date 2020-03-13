//**********************************************************************************************************************
//
//  BXLabelView.swift
//	BXLabelViews communicate with each other and decide on a common maximum width for localization purposes
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// All BXLabelViews within a BXLabelGroup get a common width assigned to them. This helps with localization,
/// as the widest string determines how wide all labels will be. That way nothing gets clipped.

public struct BXLabelGroup<Content> : View where Content:View
{
	// Params
	
	private var content:()->Content
	private var labelGroupID:String

	// State
	
	@State private var labelWidth:CGFloat = 60.0
	
	// Init
	
	public init(@ViewBuilder content:@escaping ()->Content)
	{
		self.content = content
		self.labelGroupID = UUID().uuidString
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
				
				var maxSize = CGSize.zero
				
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
        set
        {
            self[BXLabelGroupIDKey.self] = newValue
        }

        get
        {
            return self[BXLabelGroupIDKey.self]
        }
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
        set
        {
            self[BXLabelWidthKey.self] = newValue
        }

        get
        {
            return self[BXLabelWidthKey.self]
        }
    }
}

struct BXLabelWidthKey : EnvironmentKey
{
    static let defaultValue:Binding<CGFloat> = Binding.constant(60.0)
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -


public extension View
{
	// Measures the size of a View and attaches a preference (with its size)
	
	func measureViewSize(forGroupID groupID:String) -> some View
	{
		self.background( GeometryReader
		{
			Color.clear.preference(
				key: BXViewSizeKey.self,
				value: [BXViewSizeData(groupID:groupID, size:$0.size)])
		})
	}
}


/// The key needed to attach size data to a View

struct BXViewSizeKey : PreferenceKey
{
	typealias Value = [BXViewSizeData]

	static var defaultValue:[BXViewSizeData] = []

    static func reduce(value:inout [BXViewSizeData], nextValue:()->[BXViewSizeData])
    {
		value.append(contentsOf: nextValue())
    }
}

/// The attached data contains the size and a groupID to filter out unwanted candidates when deciding on a common label width

struct BXViewSizeData : Equatable
{
	let groupID:String
    let size:CGSize
}


//----------------------------------------------------------------------------------------------------------------------
