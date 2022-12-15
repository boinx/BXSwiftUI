//**********************************************************************************************************************
//
//  BXCustomSlider.swift
//	A custom implementation for a slider
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


public struct BXCustomSlider : View
{
	// Params
	
	private var value:Binding<Double>
	private var range:ClosedRange<Double>
	private var response:BXSliderResponse = .linear
	private var color:Color = .accentColor
	private var trackWidth:CGFloat = 4
	private var knobRadius:CGFloat = 6
	private var knobStrokeWidth:CGFloat = 1.5
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxColorTheme) private var bxColorTheme
	@Environment(\.bxUndoManagerProvider) private var undoManagerProvider
	@Environment(\.bxUndoName) private var undoName

	// Init
	
	public init(value:Binding<Double>, range:ClosedRange<Double> = 0.0...1.0, response:BXSliderResponse = .linear, color:Color = .accentColor, trackWidth:CGFloat = 4, knobRadius:CGFloat = 6, knobStrokeWidth:CGFloat = 1.5, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.value = value
		self.range = range
		self.response = response
		self.color = color
		self.trackWidth = trackWidth
		self.knobRadius = knobRadius
		self.knobStrokeWidth = knobStrokeWidth
		self.onBegan = onBegan
		self.onEnded = onEnded
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Appearance
	
	private var usedTrackColor : Color
	{
		return self.color
	}
	
	private var unusedTrackColor : Color
	{
		let gray = colorScheme == .dark ? 1.0 : 0.0
		let alpha = colorScheme == .dark ? 0.1 : 0.2
		return Color(white:gray, opacity:alpha)
	}
	
	private var knobStrokeColor : Color
	{
		return bxColorTheme.contentColor(for:colorScheme)
	}

	private var knobFillColor : Color
	{
		colorScheme == .dark ?
			bxColorTheme.backgroundColor(for:colorScheme) :
			Color.white
	}


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Layout
	
	private func x(for value:Double, width:CGFloat) -> CGFloat
	{
		let v0 = range.lowerBound
		let v1 = range.upperBound
		let dv = v1 - v0
		let fraction = dv>0 ? (value-Double(v0))/dv : 0.0
		let x = knobRadius + CGFloat(fraction) * (width-2*knobRadius)
		return x
	}

	private func value(for x:CGFloat, width:CGFloat) -> Double
	{
		let v0 = range.lowerBound
		let v1 = range.upperBound
		let x0 = knobRadius
		let x1 = width - knobRadius
		let dx = x1 - x0
		var fraction = dx>0 ? (x-x0)/dx : 0.0
		fraction = fraction.clipped(to:0.0...1.0)
		return v0 + Double(fraction) * (v1-v0)
	}

	private func barWidth(for width:CGFloat) -> CGFloat
	{
		return x(for:self.value.wrappedValue, width:width)
	}
	
	private func knobOffset(width:CGFloat) -> CGFloat
	{
		return x(for:self.value.wrappedValue, width:width) - knobRadius
	}
	

//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Event Handling
	
	// Counts up each time we go through the onChanged handler of the DragGesture
	
	@GestureState private var dragIteration = 0
	@State private var undoHelper = BXUndoGroupingHelper()


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
						.fill(self.usedTrackColor)
						.frame(width:self.barWidth(for:geometry.size.width), height:self.trackWidth)
						
					Rectangle()
						.fill(self.unusedTrackColor)
						.frame(height:self.trackWidth)
				}
				.clipShape(RoundedRectangle(cornerRadius:0.5*self.trackWidth))
				
				// Draw the thumb
				
				ZStack
				{
					Circle()
						.fill(self.knobFillColor)
						.frame(width:2*self.knobRadius, height:2*self.knobRadius)
						.offset(x:self.knobOffset(width:geometry.size.width), y:0)

					Circle()
						.stroke(self.knobStrokeColor, lineWidth:self.knobStrokeWidth)
						.frame(width:2*self.knobRadius, height:2*self.knobRadius)
						.offset(x:self.knobOffset(width:geometry.size.width), y:0)
				}

				// Handle drag events
				
				Color(white:0.0, opacity:0.01)
					.gesture( DragGesture(minimumDistance:0.0)
					
					.updating($dragIteration)
					{
						_,iteration,_ in iteration += 1
					}
					
					.onChanged()
					{
						// When dragging starts, open an undo group

						if self.dragIteration <= 1
						{
							self.undoHelper.undoManager = self.undoManagerProvider.undoManager
							self.undoHelper.beginUndoGrouping()
							self.onBegan?()
						}

						// Update the current value of the chosen knob

						let value = self.value(for:$0.location.x, width:geometry.size.width).clipped(to:self.range)
						self.value.wrappedValue = value
					}

					// When the drag ends, close the undo group and reset state

					.onEnded
					{
						_ in

						self.onEnded?()
						self.undoHelper.endUndoGrouping(self.undoName)
					}
				)
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

