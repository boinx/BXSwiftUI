//**********************************************************************************************************************
//
//  BXStrokedButtonStyle.swift
//	A custom style for Button
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXStrokedButtonStyle : ButtonStyle
{
	private let isHilited:Bool
	
	public init(isHilited:Bool = false)
	{
		self.isHilited = isHilited
	}

	// Unfortunately @Environment values cannot be accessed directly from a ButtonStyle, so
	// we will create a private subview, which does have access to the @Environment values.
	
    public func makeBody(configuration:BXStrokedButtonStyle.Configuration) -> some View
    {
		_BXStrokedButton(configuration:configuration, isHilited:isHilited)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// Internal view type that does the actual rendering on behalf of the BXStrokedButtonStyle.
// Since it is a View, it does have access to @Environment values!

fileprivate struct _BXStrokedButton : View
{
	// Params
	
	let configuration:ButtonStyleConfiguration
	let isHilited:Bool

	// Environment
	
	@Environment(\.isEnabled) var isEnabled
	#if os(macOS)
	@Environment(\.controlSize) var controlSize
	#endif
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.bxColorTheme) var bxColorTheme

	// Exact appearance depends on environment values
	
	private func radius(for geometry:GeometryProxy) -> CGFloat
	{
		0.25 * geometry.size.height
	}
	
	private var padding : EdgeInsets
	{
		#if os(macOS)
		switch controlSize
		{
			case .regular: 	return EdgeInsets(top:2, leading:12, bottom:3, trailing:12)
			case .small: 	return EdgeInsets(top:2, leading:12, bottom:2, trailing:12)
			case .mini: 	return EdgeInsets(top:1, leading:12, bottom:1, trailing:12)
			default: 		return EdgeInsets(top:2, leading:12, bottom:3, trailing:12)
		}
		#else
		return EdgeInsets(top:4, leading:12, bottom:5, trailing:12)
		#endif
	}
	
	#if os(macOS)
	
	private var fillColor : Color
	{
		if configuration.isPressed || isHilited
		{
			return bxColorTheme.hiliteColor(for:colorScheme)
		}
		
		return colorScheme == .dark ? bxColorTheme.fillColor(for:colorScheme) : .white
	}

	private var textColor : Color
	{
		configuration.isPressed || isHilited ? .white : .primary
	}
	
	private var strokeColor : Color
	{
		colorScheme == .dark ?
			self.bxColorTheme.strokeColor(for:colorScheme) :
			self.bxColorTheme.strokeColor(for:colorScheme)
	}
	
	#else
	
	private var fillColor : Color
	{
		if configuration.isPressed || isHilited
		{
			return Color.primary.opacity(0.2)
		}
		
		return Color.clear
	}

	private var textColor : Color
	{
		.primary
	}
	
	private var strokeColor : Color
	{
		.primary
	}

	#endif

	// Build the view
	
    var body: some View
    {
		// Label
		
		self.configuration.label
			.foregroundColor(self.textColor)
            .padding(padding)

			// Button shape
			
            .background(
            
				GeometryReader
				{
					geometry in
					
					
//					ZStack
//					{
//						RoundedRectangle(cornerRadius:self.radius(for:geometry))
//							.fill(self.fillColor)
//
//						RoundedRectangle(cornerRadius:self.radius(for:geometry)-0.5)
//							.stroke(self.strokeColor, lineWidth:1)
//							.padding(0.5)
//					}

					// Instead of drawing a ZStack with two RoundedRectangles (which produces glitches on non-retina
					// screens), we'll draw a button with a double width stroke. The parts outside the bounds will be
					// clipped away with the cornerRadius modifier, thus yielding a single width stroke.
					
					ZStack
					{
						self.fillColor
							.overlay( RoundedRectangle(cornerRadius:self.radius(for:geometry)).stroke(self.strokeColor, lineWidth:2) )
							.cornerRadius(self.radius(for:geometry))
						
						// Disable window dragging when clicking on buttons
						
						#if os(macOS)
						BXNonDraggingView()
						#endif
					}
				}
			)
			
			// Dimmed when disabled
			
			.reducedOpacityWhenDisabled()
    }
}


//----------------------------------------------------------------------------------------------------------------------


#if os(macOS)

public struct BXNonDraggingView : NSViewRepresentable
{
	public func makeNSView(context:Context) -> _BXNonDraggingView
    {
		return _BXNonDraggingView(frame:.zero)
    }


	public func updateNSView(_ view:_BXNonDraggingView, context:Context)
    {

    }
}


public class _BXNonDraggingView : NSView
{
	public override var mouseDownCanMoveWindow: Bool
	{
		return false
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------
