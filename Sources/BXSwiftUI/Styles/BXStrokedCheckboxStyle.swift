//**********************************************************************************************************************
//
//  BXStrokedCheckboxStyle.swift
//	A custom look for checkboxes
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXStrokedCheckboxStyle : ToggleStyle
{
	public init() {}
    
	// Unfortunately @Environment values cannot be accessed directly from a ToggleStyle, so
	// we will create a private subview, which does have access to the @Environment values.
	
    public func makeBody(configuration: Self.Configuration) -> some View
    {
		_BXStrokedCheckbox(configuration:configuration)
    }
}


//----------------------------------------------------------------------------------------------------------------------


// Internal view type that does the actual rendering on behalf of the BXStrokedCheckboxStyle.
// Since it is a View, it does have access to @Environment values!

fileprivate struct _BXStrokedCheckbox : View
{
	// Params
	
	let configuration:ToggleStyle.Configuration
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.controlSize) private var controlSize
	@Environment(\.hasMultipleValues) private var hasMultipleValues
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxColorTheme) private var bxColorTheme
	@Environment(\.bxUndoManagerProvider) private var undoManagerProvider
	@Environment(\.bxUndoName) private var undoName

	// Layout
	
	private var edge:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 16.0
			case .small: 		return 12.0
			case .mini: 		return 9.0
			
			default:	return 15.0
		}
	}

	private var radius:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 3.0
			case .small: 		return 2.0
			case .mini: 		return 2.0
			
			default:	return 3.0
		}
	}

	private var checkmarkOffset:CGPoint
	{
		switch controlSize
		{
			case .regular: 		return CGPoint(0.5,-0.5)
			case .small: 		return CGPoint(0.5,0.0)
			case .mini: 		return CGPoint(0.0,0.0)
			default:			return CGPoint(0.5,-0.5)
		}
	}

	private var spacing:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 8
			case .small: 		return 6
			case .mini: 		return 4
			
			default:	return 8
		}
	}

	// Appearance
	
	private var strokeColor : Color
	{
		colorScheme == .dark ?
			self.bxColorTheme.strokeColor(for:colorScheme, isEnabled:isEnabled) :
			self.bxColorTheme.strokeColor(for:colorScheme, isEnabled:isEnabled)
	}

	private var offFillColor : Color
	{
		let gray = 1.0
		let alpha = colorScheme == .dark ? 0.07 : 1.0
		return Color(white:gray,opacity:alpha)
	}

	private var onFillColor : Color
	{
		return isEnabled ? bxColorTheme.hiliteColor(for:colorScheme) : offFillColor
	}

	private var checkmarkColor : Color
	{
		if isEnabled { return Color.white }
		return bxColorTheme.contentColor(for:colorScheme)
	}

	// Build the view
	
	var body: some View
	{
		let fillColor = configuration.isOn || self.hasMultipleValues ? onFillColor : offFillColor
		
		return HStack(spacing:spacing)
		{
			// Checkbox body
			
			// The following drawing strategy produces better results (no artifacts on non-retina screens) than
			// using a ZStack with two RoundedRectangles. This is important for external screens that run at @1x.
			
			fillColor
				.frame(width:edge, height:edge)
				
				// Double width stroke will be clipped in next line
				.overlay( RoundedRectangle(cornerRadius:radius).stroke(self.strokeColor,lineWidth:2) )
				
				// Creates rounded corners AND clips the stroke that lies outside the bounds
				.cornerRadius(radius)
			
			// Checkmark
			
			.overlay( Group
			{
				if self.hasMultipleValues
				{
					BXImage(systemName:"minus")
				}
				else if configuration.isOn
				{
					Text("✓")
						.bold()
						.foregroundColor(self.checkmarkColor)
						.offset(x:checkmarkOffset.x, y:checkmarkOffset.y)
				}
			})
			
			// Label
			
			configuration.label
		}
		
		// Dim when disabled
		
		.reducedOpacityWhenDisabled()
		
		// Event handling
		
		.onTapGesture
		{
			if self.hasMultipleValues
			{
				self.configuration.$isOn.wrappedValue = true
				self.undoManagerProvider.undoManager?.setActionName(self.undoName)
			}
			else
			{
				self.configuration.$isOn.wrappedValue.toggle()
				self.undoManagerProvider.undoManager?.setActionName(self.undoName)
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
