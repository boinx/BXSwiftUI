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
		self.bxColorTheme.strokeColor(for:colorScheme)
		
//		colorScheme == .dark ?
//			self.bxColorTheme.strokeColor(for:colorScheme, isEnabled:isEnabled) :
//			self.bxColorTheme.strokeColor(for:colorScheme, isEnabled:isEnabled)
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
		.environment(\.bxSegmentGroupID, self.id)
		.environment(\.bxSegmentWidth, self.$segmentWidth)
		.environment(\.bxSegmentIndex, self.value)
		
		// Decide on common width for all segments (use widest segment as reference)
		
		.onPreferenceChange(BXSegmentSizeKey.self)
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
		
		// Apply stroke with rounded corners. The 2pt width stroke will be
		// clipped to 1pt with the cornerRadius modifier that follow below.
		
		.overlay(
			RoundedRectangle(cornerRadius:cornerRadius)
				.stroke(self.strokeColor, lineWidth:2)
		)
		
		// Clip the corners of the outer segments
		
		.cornerRadius(cornerRadius)

		// Dim when disabled
		
		.reducedOpacityWhenDisabled()
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public struct BXSegment<Content> : View where Content:View
{
	// Params
	
	private var fixedWidth:CGFloat? = nil
	private var value:Int
	private var action:()->Void
	private var content:()->Content

	// Environment
	
	@Environment(\.bxSegmentGroupID) private var id
	@Environment(\.bxSegmentWidth) private var segmentWidth
	@Environment(\.bxSegmentIndex) var bxSegmentIndex
	@Environment(\.isEnabled) var isEnabled
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.bxColorTheme) var bxColorTheme

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
					.padding(.top,2)
					.padding(.bottom,3)
					.frame(width:fixedWidth)
			}
			else
			{
				HStack { self.content() }
					.padding(.horizontal,10)
					.padding(.top,2)
					.padding(.bottom,3)
					
					// Measure segment width
					
					.measureSegmentSize(forGroupID:self.id)
					
					// Resize to common width
					
					.resizeSegment(to:self.segmentWidth, for:self.id, alignment:.center)
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
				bxColorTheme.fillColor(for:colorScheme, isEnabled:true, enhanceBy:1) //Color.clear
		}
		else
		{
			return self.value == self.bxSegmentIndex.wrappedValue ?
				bxColorTheme.hiliteColor(for:colorScheme, isEnabled:true, enhanceBy:1) :
				Color.white
		}
	}

	/// Text color for this segment
	
	var contentColor : Color
	{
		if colorScheme == .dark
		{
			return self.value == self.bxSegmentIndex.wrappedValue ?
				(isEnabled ? bxColorTheme.backgroundColor() : Color.white) :
				bxColorTheme.contentColor(for:colorScheme, isEnabled:true, enhanceBy:1)
		}
		else
		{
			return self.value == self.bxSegmentIndex.wrappedValue ?
				Color.white :
				bxColorTheme.contentColor(for:colorScheme, isEnabled:true, enhanceBy:1)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public extension View
{
	// Measures the size of a View and attaches a preference (with its size)
	
	func measureSegmentSize(forGroupID groupID:String) -> some View
	{
		self.background( GeometryReader
		{
			Color.clear.preference(
				key: BXSegmentSizeKey.self,
				value: [BXSegmentSizeData(groupID:groupID, size:$0.size)])
		})
	}
	
	/// Resizes the view to the width of a particular group.
	
	func resizeSegment(to width:Binding<CGFloat>, for groupID:String, alignment:Alignment = .leading) -> some View
	{
		self
		
			// Measure the label size and attach a preference (metadata)
			
			.measureSegmentSize(forGroupID:groupID)

			// Resize the label to the decided upon common width
			
			.frame(minWidth:width.wrappedValue, alignment:alignment)
	}
}


/// The key needed to attach size data to a View

struct BXSegmentSizeKey : PreferenceKey
{
	typealias Value = [BXSegmentSizeData]

	static var defaultValue:[BXSegmentSizeData] = []

    static func reduce(value:inout [BXSegmentSizeData], nextValue:()->[BXSegmentSizeData])
    {
		value.append(contentsOf: nextValue())
    }
}


/// The attached data contains the size and a groupID to filter out unwanted candidates when deciding on a common label width

struct BXSegmentSizeData : Equatable
{
	let groupID:String
    let size:CGSize
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public extension EnvironmentValues
{
    var bxSegmentGroupID:String
    {
        set { self[BXSegmentGroupIDKey.self] = newValue }
        get { return self[BXSegmentGroupIDKey.self] }
    }
}

struct BXSegmentGroupIDKey : EnvironmentKey
{
    static let defaultValue:String = "defaultGroup"
}


//----------------------------------------------------------------------------------------------------------------------


public extension EnvironmentValues
{
    var bxSegmentWidth:Binding<CGFloat>
    {
        set { self[BXSegmentWidthKey.self] = newValue }
        get { return self[BXSegmentWidthKey.self] }
    }
}

struct BXSegmentWidthKey : EnvironmentKey
{
    static let defaultValue:Binding<CGFloat> = Binding.constant(60.0)
}


//----------------------------------------------------------------------------------------------------------------------


public extension EnvironmentValues
{
    var bxSegmentIndex:Binding<Int>
    {
        set { self[BXSegmentIndexKey.self] = newValue }
        get { return self[BXSegmentIndexKey.self] }
    }
}

struct BXSegmentIndexKey : EnvironmentKey
{
    static let defaultValue:Binding<Int> = Binding.constant(0)
}


//----------------------------------------------------------------------------------------------------------------------
