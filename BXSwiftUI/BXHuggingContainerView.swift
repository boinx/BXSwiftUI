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
		
//			// Measure the required size of the content
//			
//			.measureViewSize(forGroupID:self.id)
//
//			// Make view as large as needed, but at LEAST the minimum size
//			
//			.onPreferenceChange(BXViewSizeKey.self)
//			{
//				preferences in
//				
//				var maxSize = CGSize(self.minWidth,self.minHeight)
//				
//				for metadata in preferences
//				{
//					if metadata.groupID == self.id
//					{
//						maxSize.width = max(maxSize.width, metadata.size.width)
//						maxSize.height = max(maxSize.height, metadata.size.height)
//					}
//				}
//				
//				self.size = maxSize
//			}
//			
//			// Resize to final size
//			
//			.frame(width:self.size.width, height:self.size.height)
	}

}


//----------------------------------------------------------------------------------------------------------------------
