//**********************************************************************************************************************
//
//  BXCircularSlider.swift
//	A circular slider for SwiftUI
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
	@Environment(\.controlSize) private var controlSize
	@Environment(\.hasMultipleValues) private var hasMultipleValues
	@Environment(\.undoManager) private var undoManager
	@Environment(\.undoName) private var undoName

	// Sizing depends on environment controlSize
	
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

	// Build the view
	
	var body: some View
	{
		let fillColor = configuration.isOn || self.hasMultipleValues ?
			Color.accentColor :
			Color(white:1.0, opacity:0.07)
		
		return HStack
		{
			ZStack()
			{
				// Fill
				
				RoundedRectangle(cornerRadius:radius)
					.foregroundColor(fillColor)
					.frame(width:edge, height:edge)

				// Stroke
				
				RoundedRectangle(cornerRadius:radius)
					.stroke(Color.gray, lineWidth:0.5)
					.frame(width:edge, height:edge)
				
				// Content
				
				if self.hasMultipleValues
				{
					Image(systemName:"minus")
				}
				else if configuration.isOn
				{
					Text("✓").bold().offset(x:offset, y:0)
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
