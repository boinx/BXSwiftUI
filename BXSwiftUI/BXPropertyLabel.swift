//**********************************************************************************************************************
//
//  BXPropertyLabel.swift
//	PropertyLabels communicate with each other and decide on a common maximum width for localization purposes
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXPropertyLabel : View
{
	var title:String = ""
//	var width:CGFloat = 70.0
	var width:Binding<CGFloat>? = nil

	private var minWidth:CGFloat
	{
		width?.wrappedValue ?? 0.0
	}
	
	public init(_ title:String, width:Binding<CGFloat>? = nil)
	{
		self.title = title
		self.width = width
	}
	
	public var body: some View
	{
		// The title consists of a single Text item
		
		Text(title)
		
			// Measure its size and attach a preference (with its width)
			
			.background( GeometryReader
			{
				Color.clear.preference(
					key:PropertyLabelKey.self,
					value:[PropertyLabelData(width:$0.size.width)])
			})
			
			// Resize the Text to the desired width - which will be the maximum width of all PropertyLabels
			
			.frame(minWidth:self.minWidth, alignment:.leading)
	}
}


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	// Stores the width of the widest BXPropertyLabel in the maxLabelWidth Binding - which is important when
	// localizing for languages with longer strings. The controls will be left aligned at this width.


	func resizePropertyLabels(to maxLabelWidth:Binding<CGFloat>) -> some View
	{
		return self.onPreferenceChange(PropertyLabelKey.self)
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


/// Metadata to be attached to BXPropertyLabel views

public struct PropertyLabelData : Equatable
{
    public let width:CGFloat
}


public struct PropertyLabelKey : PreferenceKey
{
	public typealias Value = [PropertyLabelData]

	public static var defaultValue:[PropertyLabelData] = []

    public static func reduce(value:inout [PropertyLabelData], nextValue:()->[PropertyLabelData])
    {
		value.append(contentsOf: nextValue())
    }
}


//----------------------------------------------------------------------------------------------------------------------
