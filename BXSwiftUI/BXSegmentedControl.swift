//**********************************************************************************************************************
//
//  BXSegmentedControl.swift
//	SwiftUI implementation that looks like the UISegmentedControl
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXSegmentedControl<Content> : View where Content:View
{
	// Params
	
	private var id:String
	private var value:Binding<Int>
	private var cornerRadius:CGFloat
	private var content:()->Content
	
	// Environment
	
	@Environment(\.isEnabled) var isEnabled
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.bxColorTheme) var bxColorTheme
	
	// State
	
	@State private var segmentWidth:CGFloat = 60.0
	
	// Init
	
	public init(value:Binding<Int>, cornerRadius:CGFloat = 4.0, @ViewBuilder content:@escaping ()->Content)
	{
		self.id = UUID().uuidString
		self.value = value
		self.cornerRadius = cornerRadius
		self.content = content
	}
	
	// Build View
	
	public var body: some View
	{
		HStack(spacing:0)
		{
			content()
		}
		.environment(\.bxLabelGroupID, self.id)
		
		.environment(\.bxLabelWidth, self.$segmentWidth)
		.environment(\.bxSegmentIndex, self.value)
		
		.onPreferenceChange(BXViewSizeKey.self)
		{
			preferences in
			
			var maxSize = CGSize(0.0,0.0)
			
			for metadata in preferences
			{
				if metadata.groupID == self.id
				{
					maxSize.width = max(maxSize.width, metadata.size.width)
					maxSize.height = max(maxSize.height, metadata.size.height)
				}
			}
			
			self.segmentWidth = maxSize.width
		}
		
		.cornerRadius(cornerRadius)

		.overlay(
			RoundedRectangle(cornerRadius:cornerRadius)
				.stroke(self.bxColorTheme.strokeColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:1), lineWidth:0.5)
		)
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXSegment<Content> : View where Content:View
{
	// Params
	
	private var value:Int
	private var content:()->Content

	// Environment
	
	@Environment(\.bxLabelGroupID) private var id
	@Environment(\.bxLabelWidth) private var segmentWidth
	@Environment(\.isEnabled) var isEnabled
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.bxColorTheme) var bxColorTheme
	@Environment(\.bxSegmentIndex) var bxSegmentIndex

	// Init
	
	public init(value:Int, @ViewBuilder content:@escaping ()->Content)
	{
		self.value = value
		self.content = content
	}
	
	// Build View
	
	public var body: some View
	{
		HStack { self.content() }
		
			.padding(.horizontal,10)
			.padding(.vertical,2)
			
			.measureViewSize(forGroupID:self.id)
			
			.resizeView(to:self.segmentWidth, for:self.id, alignment:.center)
			
			.background( Rectangle().fill(self.fillColor) )
			.foregroundColor(self.contentColor)
			
			.contentShape(Rectangle())
			
			.onTapGesture
			{
				self.bxSegmentIndex.wrappedValue = self.value
			}
	}
	
	var fillColor : Color
	{
		self.value == self.bxSegmentIndex.wrappedValue ?
			bxColorTheme.fillColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:1) :
			bxColorTheme.backgroundColor()
	}
	
	var contentColor : Color
	{
		self.value == self.bxSegmentIndex.wrappedValue ?
			bxColorTheme.backgroundColor() :
			bxColorTheme.contentColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:1)
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public extension EnvironmentValues
{
    var bxSegmentIndex:Binding<Int>
    {
        set
        {
            self[BXSegmentIndexKey.self] = newValue
        }

        get
        {
            return self[BXSegmentIndexKey.self]
        }
    }
}

struct BXSegmentIndexKey : EnvironmentKey
{
    static let defaultValue:Binding<Int> = Binding.constant(0)
}


//----------------------------------------------------------------------------------------------------------------------
