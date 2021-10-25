//**********************************************************************************************************************
//
//  BXRangeSlider.swift
//	A slider that lets you define a lower and an upper value
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXRangeSlider : View
{
	// Params
	
	private var lowerValue:Binding<Double>
	private var upperValue:Binding<Double>
	private var range:ClosedRange<Double>
	private var knobSize:CGFloat = 12
	private var trackWidth:CGFloat = 3
	private var isUniqueValue:Bool = true
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxColorTheme) private var bxColorTheme
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// Init
	
	public init(lowerValue:Binding<Double>, upperValue:Binding<Double>, range:ClosedRange<Double> = 0.0...360.0, knobSize:CGFloat = 12, trackWidth:CGFloat = 3, isUniqueValue:Bool = true, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.lowerValue = lowerValue
		self.upperValue = upperValue
		self.range = range
		self.knobSize = knobSize
		self.trackWidth = trackWidth
		self.isUniqueValue = isUniqueValue
		self.onBegan = onBegan
		self.onEnded = onEnded
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Appearance
	
	private var usedTrackColor : Color
	{
		return isEnabled ? bxColorTheme.hiliteColor() : self.unusedTrackColor
	}
	
	private var unusedTrackColor : Color
	{
		return colorScheme == .dark ? Color(white:1.0,opacity:0.15) : Color(white:0.0,opacity:0.25)
	}
	
	private var knobFillColor : Color
	{
		return colorScheme == .dark ? bxColorTheme.backgroundColor(for:colorScheme) : Color.white
	}

	private var knobStrokeColor : Color
	{
		return colorScheme == .dark ? bxColorTheme.contentColor(for:colorScheme) : Color(white:0.35,opacity:1.0)
	}

	private var knobStrokeWidth : CGFloat
	{
		return colorScheme == .dark ? 1.5 : 0.5
	}


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Layout
	
	private func lowerKnobOffset(for width:CGFloat) -> CGFloat
	{
		let x0 = self.x(for:lowerValue.wrappedValue, width:width)
		let dx = 0.5*knobSize
		return x0 - dx
	}
	
	private func upperKnobOffset(for width:CGFloat) -> CGFloat
	{
		let x1 = self.x(for:upperValue.wrappedValue, width:width)
		let dx = 0.5*knobSize
		return x1 - dx
	}
	
	private func lowerBarWidth(for width:CGFloat) -> CGFloat
	{
		let x0 = self.x(for:lowerValue.wrappedValue, width:width)
		let dx = 0.5*knobSize
		return max(0.0, x0-dx)
	}
	
	private func upperBarWidth(for width:CGFloat) -> CGFloat
	{
		let x1 = self.x(for:upperValue.wrappedValue, width:width)
		let dx = 0.5*knobSize
		return max(0.0, width-x1-dx)
	}
	
	private func middleBarWidth(for width:CGFloat) -> CGFloat
	{
		return width - lowerBarWidth(for:width) - upperBarWidth(for:width) - knobSize - knobSize
	}

	private func x(for value:Double, width:CGFloat) -> CGFloat
	{
		let v0 = range.lowerBound
		let v1 = range.upperBound
		let dv = v1 - v0
		
		let fraction = dv>0 ? (value-Double(v0)) / dv : 0.0
		let x = 0.5*knobSize + CGFloat(fraction) * (width-knobSize)
		return x
	}

	private func value(for x:CGFloat, width:CGFloat) -> Double
	{
		let v0 = range.lowerBound
		let v1 = range.upperBound
		
		let x0 = 0.5*knobSize
		let x1 = width - 0.5*knobSize
		let dx = x1 - x0
		
		let fraction = dx>0 ? (x-x0)/dx : 0.0
		return v0 + Double(fraction) * (v1-v0)
	}


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Event Handling
	
	// 0 for lowerValue, 1 for upperValue
	
	@State private var dragKnobIndex = 0
	
	// Counts up each time we go through the onChanged handler of the DragGesture
	
	@State private var dragIteration = 0


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Build View
	
	public var body: some View
	{
		GeometryReader
		{
			geometry in
			
			// We need a ZStack because the knobs can overlap, so using a single HStack is not an option!
			
			ZStack(alignment:.leading)
			{
				// Draw the track
				
				HStack(spacing:0)
				{
					Rectangle()
						.fill(self.unusedTrackColor)
						.frame(width:self.lowerBarWidth(for:geometry.size.width), height:self.trackWidth)

					Rectangle()
						.fill(self.usedTrackColor)
						.frame(height:self.trackWidth)

					Rectangle()
						.fill(self.unusedTrackColor)
						.frame(width:self.upperBarWidth(for:geometry.size.width), height:self.trackWidth)
				}
				.clipShape(RoundedRectangle(cornerRadius:1.5))
				.frame(height:self.knobSize)
				
				// Lower knob

				if self.isUniqueValue
				{
					BXRangeSliderKnob(
						fillColor:self.knobFillColor,
						strokeColor:self.knobStrokeColor,
						strokeWidth:self.knobStrokeWidth)
							.frame(width:self.knobSize, height:self.knobSize)
							.offset(x:self.lowerKnobOffset(for:geometry.size.width), y:0)
				}
				
				// Upper knob

				if self.isUniqueValue
				{
					BXRangeSliderKnob(
						fillColor:self.knobFillColor,
						strokeColor:self.knobStrokeColor,
						strokeWidth:self.knobStrokeWidth)
							.frame(width:self.knobSize, height:self.knobSize)
							.offset(x:self.upperKnobOffset(for:geometry.size.width), y:0)
				}
			}
			
			// Dim when disabled
			
			.compositingGroup()
			.reducedOpacityWhenDisabled()
			
			// Add a drag handler for event handling

			.contentShape(Rectangle())
			
			.gesture( DragGesture(minimumDistance:0.0)

				.onChanged()
				{
					let value = self.value(for:$0.location.x, width:geometry.size.width)

					// When dragging starts, open an undo group and decide which knob will be dragged.
					// Choose the closest one to the mouse click.

					if self.dragIteration == 0
					{
						self.undoManager?.groupsByEvent = false
						self.undoManager?.beginUndoGrouping()
						if abs(value-self.lowerValue.wrappedValue) <= abs(value-self.upperValue.wrappedValue)
						{
							self.dragKnobIndex = 0
						}
						else
						{
							self.dragKnobIndex = 1
						}
						
						self.onBegan?()
					}
					
					self.dragIteration += 1

					// Update the current value of the chosen knob

					if self.dragKnobIndex == 0
					{
						self.lowerValue.wrappedValue = value
					}
					else
					{
						self.upperValue.wrappedValue = value
					}
				}

				// When the drag ends, close the undo group and reset state

				.onEnded
				{
					_ in

					self.onEnded?()
					self.undoManager?.setActionName(self.undoName)
					self.undoManager?.endUndoGrouping()
					self.undoManager?.groupsByEvent = true
					self.dragIteration = 0
				}
			)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXRangeSliderKnob : View
{
	var fillColor:Color
	var strokeColor:Color
	var strokeWidth:CGFloat
	
	public var body: some View
	{
		ZStack
		{
			Circle()
				.fill(self.fillColor)
				
			Circle()
				.stroke(self.strokeColor ,lineWidth:strokeWidth)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

