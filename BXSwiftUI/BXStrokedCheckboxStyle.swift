//**********************************************************************************************************************
//
//  BXStrokedCheckboxStyle.swift
//	A custom look for checkboxes
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


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
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.controlSize) private var controlSize
	@Environment(\.hasMultipleValues) private var hasMultipleValues
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// Layout
	
	private var edge:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 15.0
			case .small: 		return 12.0
			case .mini: 		return 9.0
			
			@unknown default:	return 15.0
		}
	}

	private var radius:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 3.0
			case .small: 		return 2.0
			case .mini: 		return 2.0
			
			@unknown default:	return 3.0
		}
	}

	private var offset:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 0.5
			case .small: 		return 0.0
			case .mini: 		return 0.0
			
			@unknown default:	return 0.5
		}
	}

	private var spacing:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 8
			case .small: 		return 6
			case .mini: 		return 4
			
			@unknown default:	return 8
		}
	}

	// Appearance
	
	private var strokeColor : Color
	{
		let gray = colorScheme == .dark ? 0.65 : 0.35
		let alpha = isEnabled ? 1.0 : 0.33
		return Color(white:gray,opacity:alpha)
	}

	private var offFillColor : Color
	{
		let gray = colorScheme == .dark ? 1.0 : 1.0
		var alpha = colorScheme == .dark ? 0.07 : 1.0
		if !isEnabled { alpha *= 0.33 }
		return Color(white:gray,opacity:alpha)
	}

	private var onFillColor : Color
	{
		let alpha = isEnabled ? 1.0 : 0.33
		return Color.accentColor.opacity(alpha)
	}

	// Build the view
	
	var body: some View
	{
		let fillColor = configuration.isOn || self.hasMultipleValues ? onFillColor : offFillColor
		
		return HStack(spacing:spacing)
		{
			ZStack()
			{
				// Fill
				
				RoundedRectangle(cornerRadius:radius)
					.foregroundColor(fillColor)
					.frame(width:edge, height:edge)

				// Stroke
				
				RoundedRectangle(cornerRadius:radius)
					.stroke(self.strokeColor, lineWidth:0.5)
					.frame(width:edge, height:edge)
				
				// Content
				
				if self.hasMultipleValues
				{
					Image(systemName:"minus")
				}
				else if configuration.isOn
				{
					Text("✓").foregroundColor(.white).bold().offset(x:offset, y:0)
				}
			}
			
			// Label
			
			configuration.label
		}
		
		// Dim when disabled
		
		.opacity(self.isEnabled ? 1.0 : 0.33)
		
		// Event handling
		
		.onTapGesture
		{
			if self.hasMultipleValues
			{
				self.configuration.$isOn.wrappedValue = true
				self.undoManager?.setActionName(self.undoName)
			}
			else
			{
				self.configuration.$isOn.wrappedValue.toggle()
				self.undoManager?.setActionName(self.undoName)
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
