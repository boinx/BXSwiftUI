//**********************************************************************************************************************
//
//  BXLabelView.swift
//	BXLabelViews communicate with each other and decide on a common maximum width for localization purposes
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// A BXLabelview returns a HStack with a Text and (optionally) up to two buttons. The content view follows afterwards.
/// The special difference to a regular HStack is, that all BXLabelviews communicate with each other and decide on a
/// common width, so that the widest label can be displayed without truncating. This is super helpful when localizing
/// to languages with longer strings.

public struct BXLabelView<Content> : View where Content:View
{
	public typealias BXButtonBuilder = ()->BXButton
	
	private var label:String = ""
	private var width:Binding<CGFloat>? = nil
	private var button1:BXButtonBuilder? = nil
	private var button2:BXButtonBuilder? = nil
	private var button3:BXButtonBuilder? = nil
	private var content:()->Content

	@Environment(\.isEnabled) private var isEnabled

	private var minWidth:CGFloat
	{
		width?.wrappedValue ?? 0.0
	}
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, button1:BXButtonBuilder? = nil, button2:BXButtonBuilder? = nil, button3:BXButtonBuilder? = nil, @ViewBuilder content:@escaping ()->Content)
	{
		self.label = label
		self.width = width
		self.button1 = button1
		self.button2 = button2
		self.button3 = button3
		self.content = content
	}
	
	public var body: some View
	{
		HStack(alignment:.firstTextBaseline)
		{
			if self.label.count > 0 || self.button1 != nil || self.button2 != nil || self.button3 != nil
			{
				// The label consists of a Text item and optionally some buttons
			
				HStack(spacing:4)
				{
					Text(self.label)
					
					if self.button1 != nil
					{
						self.button1!()
					}
					
					if self.button2 != nil
					{
						self.button2!()
					}
					
					if self.button3 != nil
					{
						self.button3!()
					}
				}
				.opacity(isEnabled ? 1.0 : 0.33)
				
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

	func resizeBXLabelViews(to maxLabelWidth:Binding<CGFloat>) -> some View
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
