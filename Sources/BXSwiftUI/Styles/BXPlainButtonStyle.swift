//**********************************************************************************************************************
//
//  BXPlainButtonStyle.swift
//	A custom style for Button
//  Copyright ©2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXPlainButtonStyle : ButtonStyle
{
	public init()
	{

	}

	// Unfortunately @Environment values cannot be accessed directly from a ButtonStyle, so
	// we will create a private subview, which does have access to the @Environment values.
	
    public func makeBody(configuration:BXPlainButtonStyle.Configuration) -> some View
    {
		_BXPlainButton(configuration:configuration)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// Internal view type that does the actual rendering on behalf of the BXPlainButtonStyle.
// Since it is a View, it does have access to @Environment values!

fileprivate struct _BXPlainButton : View
{
	// Params
	
	let configuration:ButtonStyleConfiguration

	// Environment
	
	@Environment(\.controlSize) var controlSize

	// Exact appearance depends on environment values
	
	private func radius(for geometry:GeometryProxy) -> CGFloat
	{
		0.25 * geometry.size.height
	}
	
	private var padding : EdgeInsets
	{
		switch controlSize
		{
			case .regular: 	return EdgeInsets(top:2, leading:12, bottom:3, trailing:12)
			case .small: 	return EdgeInsets(top:2, leading:12, bottom:2, trailing:12)
			case .mini: 	return EdgeInsets(top:1, leading:12, bottom:1, trailing:12)
			default: 		return EdgeInsets(top:2, leading:12, bottom:3, trailing:12)
		}
	}
	
	private var fillColor : Color
	{
		Color.primary.opacity(configuration.isPressed ? 0.3 : 0.1)
	}

	private var textColor : Color
	{
		Color.primary
	}
	
	private var strokeColor : Color
	{
		Color.primary
	}

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

#endif
