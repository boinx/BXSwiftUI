//**********************************************************************************************************************
//
//  BXLabelView.swift
//	BXLabelViews communicate with each other and decide on a common maximum width for localization purposes
//  Copyright ©2020-2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// A BXLabelview returns a HStack with a Text and (optionally) up to three buttons. The content follows afterwards.
/// The special difference to a regular HStack is, that all BXLabelviews within a BXLabelGroup communicate with each
/// other and decide on a common width, so that the widest label can be displayed without truncating. This is super
/// helpful when localizing to languages with longer strings.

public struct BXLabelView<Content> : View where Content:View
{
	public typealias BXButtonBuilder = ()->BXButton
	
	// Params
	
	private var label:String = ""
	private var button1:BXButtonBuilder? = nil
	private var button2:BXButtonBuilder? = nil
	private var button3:BXButtonBuilder? = nil
	private var alignment:Alignment
	private var content:()->Content

	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.bxLabelGroupID) private var bxLabelGroupID
	@Environment(\.bxLabelWidth) private var bxLabelWidth

	/// Init
	
	public init(label:String = "", button1:BXButtonBuilder? = nil, button2:BXButtonBuilder? = nil, button3:BXButtonBuilder? = nil, alignment:Alignment = .leading, @ViewBuilder content:@escaping ()->Content)
	{
		self.label = label
		self.button1 = button1
		self.button2 = button2
		self.button3 = button3
		self.alignment = alignment
		self.content = content
	}
	
	// Build View
	
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
				.lineLimit(1)
				
				.resizeLabel(to:self.bxLabelWidth, for:self.bxLabelGroupID, alignment:self.alignment)
				
				// Dimmed when disabled
				
				.reducedOpacityWhenDisabled()
			}
			
			self.content()
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public extension View
{
	// Measures the size of a View and attaches a preference (with its size)
	
	func measureLabelSize(forGroupID groupID:String) -> some View
	{
		self
		
			.background( GeometryReader
			{
				Color.clear.preference(
					key: BXLabelSizeKey.self,
					value: [BXLabelSizeData(groupID:groupID, size:$0.size)])
			})
	}
	
	/// Resizes the view to the width of a particular group.
	
	func resizeLabel(to width:Binding<CGFloat>, for groupID:String, alignment:Alignment = .leading) -> some View
	{
		self
		
			// Measure the label size and attach a preference (metadata)
			
			.measureLabelSize(forGroupID:groupID)

			// Resize the label to the decided upon common width
			
			.frame(minWidth:width.wrappedValue, alignment:alignment)
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// The key needed to attach size data to a View

struct BXLabelSizeKey : PreferenceKey
{
	typealias Value = [BXLabelSizeData]

	static var defaultValue:[BXLabelSizeData] = []

    static func reduce(value:inout [BXLabelSizeData], nextValue:()->[BXLabelSizeData])
    {
		value.append(contentsOf: nextValue())
    }
}

/// The attached data contains the size and a groupID to filter out unwanted candidates when deciding on a common label width

struct BXLabelSizeData : Equatable
{
	let groupID:String
    let size:CGSize
}


//----------------------------------------------------------------------------------------------------------------------
