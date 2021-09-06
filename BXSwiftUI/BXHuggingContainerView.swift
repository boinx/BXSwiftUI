//**********************************************************************************************************************
//
//  BXHuggingContainerView.swift
//	A view that hugs it content as closely as possible and resists infinate expansion
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// BXHuggingContainerView hugs its child view as closely as possible. It can be expanded by the child views, but will resist being stretched to infinity by
/// greedy views like Spacer or Color.

public struct BXHuggingContainerView<Content> : View where Content:View
{
	// Params
	
	private var id:String
	private var minWidth:CGFloat
	private var minHeight:CGFloat
	private var content:()->Content

	// State
	
	@State private var size = CGSize.zero
	
	// Init
	
	public init(minWidth:CGFloat = 0.0, minHeight:CGFloat = 0.0, @ViewBuilder content:@escaping ()->Content)
	{
		self.id = UUID().uuidString
		self.minWidth = minWidth
		self.minHeight = minHeight
		self.content = content
	}
	
	// Build View
	
	public var body: some View
	{
		content()
		
			// Measure the required size of the content
			
			.measureContainerSize(forGroupID:self.id)

			// Make view as large as needed, but at LEAST the minimum size
			
			.onPreferenceChange(BXContainerSizeKey.self)
			{
				preferences in
				
				var maxSize = CGSize(self.minWidth,self.minHeight)
				
				for metadata in preferences
				{
					if metadata.groupID == self.id
					{
						maxSize.width = max(maxSize.width, metadata.size.width)
						maxSize.height = max(maxSize.height, metadata.size.height)
					}
				}
				
				self.size = maxSize
			}
			
			// Resize to final size
			
			.frame(width:self.size.width, height:self.size.height)
	}

}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public extension View
{
	// Measures the size of a View and attaches a preference (with its size)
	
	func measureContainerSize(forGroupID groupID:String) -> some View
	{
		self.background( GeometryReader
		{
			Color.clear.preference(
				key: BXContainerSizeKey.self,
				value: [BXContainerSizeData(groupID:groupID, size:$0.size)])
		})
	}
	
	/// Resizes the view to the width of a particular group.
	
	func resizeContainer(to width:Binding<CGFloat>, for groupID:String, alignment:Alignment = .leading) -> some View
	{
		self
		
			// Measure the label size and attach a preference (metadata)
			
			.measureContainerSize(forGroupID:groupID)

			// Resize the label to the decided upon common width
			
			.frame(minWidth:width.wrappedValue, alignment:alignment)
	}
}


//----------------------------------------------------------------------------------------------------------------------


/// The key needed to attach size data to a View

struct BXContainerSizeKey : PreferenceKey
{
	typealias Value = [BXContainerSizeData]

	static var defaultValue:[BXContainerSizeData] = []

    static func reduce(value:inout [BXContainerSizeData], nextValue:()->[BXContainerSizeData])
    {
		value.append(contentsOf: nextValue())
    }
}

/// The attached data contains the size and a groupID to filter out unwanted candidates when deciding on a common label width

struct BXContainerSizeData : Equatable
{
	let groupID:String
    let size:CGSize
}


//----------------------------------------------------------------------------------------------------------------------
