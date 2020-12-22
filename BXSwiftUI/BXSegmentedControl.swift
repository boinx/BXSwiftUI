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
	private var minSegmentWidth:CGFloat
	private var content:()->Content
	
	// Environment
	
	@Environment(\.isEnabled) var isEnabled
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.bxColorTheme) var bxColorTheme
	
	var strokeColor:Color
	{
		colorScheme == .dark ?
			self.bxColorTheme.strokeColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:1) :
			self.bxColorTheme.strokeColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:0.5)
	}
	
	// State
	
	@State private var segmentWidth:CGFloat = 60.0
	
	// Init
	
	public init(value:Binding<Int>, cornerRadius:CGFloat = 4.0, minSegmentWidth:CGFloat = 0, @ViewBuilder content:@escaping ()->Content)
	{
		self.id = UUID().uuidString
		self.value = value
		self.cornerRadius = cornerRadius
		self.minSegmentWidth = minSegmentWidth
		self.content = content
	}
	
	// Build View
	
	public var body: some View
	{
		HStack(spacing:0)
		{
			content()
		}
		.environment(\.bxSegmentIndex, self.value)

		// Use BXLabelGroup code for measuring segment widths
		
		.environment(\.bxLabelGroupID, self.id)
		.environment(\.bxLabelWidth, self.$segmentWidth)
		
		// Decide on common width for all segments (use widest segment as reference)
		
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
			
			self.segmentWidth = max(self.minSegmentWidth, maxSize.width)
		}
		
		// Apply stroke with rounded corners
		
		.overlay(
			RoundedRectangle(cornerRadius:cornerRadius)
				.stroke(self.strokeColor, lineWidth:1.0)
		)
		.cornerRadius(cornerRadius)
		.clipped()
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXSegment<Content> : View where Content:View
{
	// Params
	
	private var fixedWidth:CGFloat? = nil
	private var value:Int
	private var action:()->Void
	private var content:()->Content

	// Environment
	
	@Environment(\.bxLabelGroupID) private var id
	@Environment(\.bxLabelWidth) private var segmentWidth
	@Environment(\.isEnabled) var isEnabled
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.bxColorTheme) var bxColorTheme
	@Environment(\.bxSegmentIndex) var bxSegmentIndex

	// Init
	
	public init(fixedWidth:CGFloat? = nil, value:Int, action:@escaping ()->Void = {}, @ViewBuilder content:@escaping ()->Content)
	{
		self.fixedWidth = fixedWidth
		self.value = value
		self.action = action
		self.content = content
	}
	
	// Build View
	
	public var body: some View
	{
		self.segment
		
			// Apply background and text color
			
			.background( Rectangle().fill(self.fillColor) )
			.foregroundColor(self.contentColor)
			
			// When clicked, select this segment and call action handler
			
			.contentShape(Rectangle())
			
			.onTapGesture
			{
				self.bxSegmentIndex.wrappedValue = self.value
				self.action()
			}
	}
	
	/// Returns either a fixed width or an ideal width segment
	
	var segment: some View
	{
		Group
		{
			if let fixedWidth = fixedWidth
			{
				HStack { self.content() }
					.padding(.horizontal,10)
					.padding(.vertical,2)
					.frame(width:fixedWidth)
			}
			else
			{
				HStack { self.content() }
					.padding(.horizontal,10)
					.padding(.vertical,2)
					
					// Measure segment width
					
					.measureViewSize(forGroupID:self.id)
					
					// Resize to common width
					
					.resizeView(to:self.segmentWidth, for:self.id, alignment:.center)
			}
		}
	}
	
	/// Background color for this segment
	
	var fillColor : Color
	{
		if colorScheme == .dark
		{
			return self.value == self.bxSegmentIndex.wrappedValue ?
				bxColorTheme.contentColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:1) :
				Color.clear
		}
		else
		{
			return self.value == self.bxSegmentIndex.wrappedValue ?
				bxColorTheme.hiliteColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:1) :
				Color.white
		}
	}
	
	/// Text color for this segment
	
	var contentColor : Color
	{
		if colorScheme == .dark
		{
			return self.value == self.bxSegmentIndex.wrappedValue ?
				bxColorTheme.backgroundColor() :
				bxColorTheme.contentColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:1)
		}
		else
		{
			return self.value == self.bxSegmentIndex.wrappedValue ?
				Color.white :
				bxColorTheme.contentColor(for:colorScheme, isEnabled:isEnabled, enhanceBy:1)
		}
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
