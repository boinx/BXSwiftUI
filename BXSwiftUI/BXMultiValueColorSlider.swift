//**********************************************************************************************************************
//
//  BXMultiValueColorSlider.swift
//	A slider that lets you define a lower and an upper value
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXMultiValueColorSlider : View
{
	// Params
	
	private var values:Binding<Set<Double>>
	private var range:ClosedRange<Double>
	private var response:BXSliderResponse = .linear
	private var color:Color = .accentColor
	private var trackWidth:CGFloat = 4
	private var knobRadius:CGFloat = 6
	private var knobStrokeWidth:CGFloat = 1.5
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil

	// Environment
	
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxColorTheme) private var bxColorTheme
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// Init
	
	public init(values:Binding<Set<Double>>, range:ClosedRange<Double> = 0.0...1.0, response:BXSliderResponse = .linear, color:Color = .accentColor, trackWidth:CGFloat = 4, knobRadius:CGFloat = 6, knobStrokeWidth:CGFloat = 1.5, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.values = values
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
		return bxColorTheme.backgroundColor(for:colorScheme)
	}


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Layout
	
	private func x(for value:Double, width:CGFloat) -> CGFloat
	{
		let v0 = range.lowerBound
		let v1 = range.upperBound
		let fraction = (value - Double(v0)) / (v1-v0)
		let w = width - 2 * knobRadius
		let x = knobRadius + CGFloat(fraction) * w
		return x
	}

	private func value(for x:CGFloat, width:CGFloat) -> Double
	{
		let v0 = range.lowerBound
		let v1 = range.upperBound
		let x0 = knobRadius
		let x1 = width - knobRadius
		
		let fraction = (x - x0) / (x1-x0)
		return v0 + Double(fraction) * (v1-v0)
	}

	private func barWidth(for width:CGFloat) -> CGFloat
	{
		let maxVal = self.values.wrappedValue.max() ?? range.lowerBound
		return x(for:maxVal, width:width)
	}
	
	private func knobOffset(for value:Double, width:CGFloat) -> CGFloat
	{
		return x(for:value, width:width) - knobRadius
	}
	

//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Event Handling
	
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
						.fill(self.usedTrackColor)
						.frame(width:self.barWidth(for:geometry.size.width), height:self.trackWidth)
						
					Rectangle()
						.fill(self.unusedTrackColor)
						.frame(height:self.trackWidth)
				}
				.clipShape(RoundedRectangle(cornerRadius:0.5*trackWidth))
				
				// Draw thumbs
				
				ForEach(Array(self.values.wrappedValue), id:\.self)
				{
					value in
					
					ZStack
					{
						Circle()
							.fill(self.knobFillColor)
							.frame(width:2*self.knobRadius, height:2*self.knobRadius)
							.offset(x:self.knobOffset(for:value, width:geometry.size.width), y:0)
							.disabled(true)
							
						Circle()
							.stroke(self.knobStrokeColor, lineWidth:self.knobStrokeWidth)
							.frame(width:2*self.knobRadius, height:2*self.knobRadius)
							.offset(x:self.knobOffset(for:value, width:geometry.size.width), y:0)
					}
				}
				
				// Handle drag events
				
				Color(white:0.0, opacity:0.01)
					.gesture( DragGesture(minimumDistance:0.0)
					
					.onChanged()
					{
						// When dragging starts, open an undo group

						if self.dragIteration == 0
						{
							self.undoManager?.groupsByEvent = false
							self.undoManager?.beginUndoGrouping()
							self.onBegan?()
						}
						
						self.dragIteration += 1

						// Update the current value of the chosen knob

						let value = self.value(for:$0.location.x, width:geometry.size.width).clipped(to:self.range)
						self.values.wrappedValue = Set([value])
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
}


//----------------------------------------------------------------------------------------------------------------------

