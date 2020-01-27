//**********************************************************************************************************************
//
//  BXLabelView.swift
//	BXLabelViews communicate with each other and decide on a common maximum width for localization purposes
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXLabelView<Content> : View where Content:View
{
	var label:String = ""
	var width:Binding<CGFloat>? = nil
	var content:()->Content
	
	private var minWidth:CGFloat
	{
		width?.wrappedValue ?? 0.0
	}
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, @ViewBuilder content:@escaping ()->Content)
	{
		self.label = label
		self.width = width
		self.content = content
	}
	
	public var body: some View
	{
		HStack
		{
			if self.label.count > 0
			{
				// The label consists of a single Text item
			
				Text(self.label)
			
					// Measure its size and attach a preference (with its width)
					
					.background( GeometryReader
					{
						Color.clear.preference(
							key:BXLabelViewKey.self,
							value:[BXLabelViewData(width:$0.size.width)])
					})
					
					// Resize the Text to the desired width - which will be the maximum width of all BXLabelViews
					
					.frame(minWidth:self.minWidth, alignment:.leading)
			}
			
			content()
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	// Stores the width of the widest BXPropertyLabel in the maxLabelWidth Binding - which is important when
	// localizing for languages with longer strings. The controls will be left aligned at this width.


	func resizeLabelColumn(to maxLabelWidth:Binding<CGFloat>) -> some View
	{
		return self.onPreferenceChange(BXLabelViewKey.self)
		{
			preferences in
			
			let maxWidth = preferences
				.map { $0.width }
				.max() ?? 60.0
			
			maxLabelWidth.wrappedValue = maxWidth
		}
	}
}



//----------------------------------------------------------------------------------------------------------------------


/// Metadata to be attached to BXLabelView views

public struct BXLabelViewData : Equatable
{
    public let width:CGFloat
}


public struct BXLabelViewKey : PreferenceKey
{
	public typealias Value = [BXLabelViewData]

	public static var defaultValue:[BXLabelViewData] = []

    public static func reduce(value:inout [BXLabelViewData], nextValue:()->[BXLabelViewData])
    {
		value.append(contentsOf: nextValue())
    }
}


//----------------------------------------------------------------------------------------------------------------------
