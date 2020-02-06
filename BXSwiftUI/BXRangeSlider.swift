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
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// Init
	
	public init(lowerValue:Binding<Double>, upperValue:Binding<Double>, range:ClosedRange<Double> = 0.0...360.0, knobSize:CGFloat = 12, trackWidth:CGFloat = 3)
	{
		self.lowerValue = lowerValue
		self.upperValue = upperValue
		self.range = range
		self.knobSize = knobSize
		self.trackWidth = trackWidth
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Appearance
	
	private var unusedTrackColor : Color
	{
		let alpha = isEnabled ? 1.0 : 0.33
		return colorScheme == .dark ? Color(white:1.0,opacity:0.15*alpha) : Color(white:0.0,opacity:0.15*alpha)
	}
	
	private var knobColor : Color
	{
		let alpha = isEnabled ? 1.0 : 0.33
		return colorScheme == .dark ? Color(white:1.0,opacity:alpha) : Color(white:0.1,opacity:alpha)
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
		let fraction = (value - Double(v0)) / (v1-v0)
		let x = 0.5*knobSize + CGFloat(fraction) * (width-knobSize)
		return x
	}

	private func value(for x:CGFloat, width:CGFloat) -> Double
	{
		let v0 = range.lowerBound
		let v1 = range.upperBound
		let x0 = 0.5*knobSize
		let x1 = width - 0.5*knobSize
		
		let fraction = (x - x0) / (x1-x0)
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

					Spacer()
						.frame(width:self.knobSize, height:self.trackWidth)

					Rectangle()
						.fill(Color.accentColor)
						.frame(width:self.middleBarWidth(for:geometry.size.width), height:self.trackWidth)

					Spacer()
						.frame(width:self.knobSize, height:self.trackWidth)

					Rectangle()
						.fill(self.unusedTrackColor)
						.frame(width:self.upperBarWidth(for:geometry.size.width), height:self.trackWidth)
				}

				// Lower knob

				Circle()
					.stroke(self.knobColor ,lineWidth:1.5)
					.frame(width:self.knobSize, height:self.knobSize)
					.offset(x:self.lowerKnobOffset(for:geometry.size.width), y:0)

				// Upper knob

				Circle()
					.stroke(self.knobColor ,lineWidth:1.5)
					.frame(width:self.knobSize, height:self.knobSize)
					.offset(x:self.upperKnobOffset(for:geometry.size.width), y:0)
			}
			
			// Hack: Apply a non-transparent (but non-visible) background color to the whole slide so that we
			// can receive mouse click events outside the track (i.e. background). That makes the UX much nicer.
			
			.background(Color(white:0.0, opacity:0.01))

			// Add a drag handler for event handling

			.gesture( DragGesture(minimumDistance:0.0)

				.onChanged()
				{
					let value = self.value(for:$0.location.x, width:geometry.size.width)

					// When dragging starts, open an undo group and decide which knob will be dragged.
					// Choose the closest one to the mouse click.

					if self.dragIteration == 0
					{
						self.undoManager?.beginUndoGrouping()
						if abs(value-self.lowerValue.wrappedValue) <= abs(value-self.upperValue.wrappedValue)
						{
							self.dragKnobIndex = 0
						}
						else
						{
							self.dragKnobIndex = 1
						}
					}

					// Update the current value of the chosen knob

					if self.dragKnobIndex == 0
					{
						self.lowerValue.wrappedValue = value
					}
					else
					{
						self.upperValue.wrappedValue = value
					}

					self.dragIteration += 1
				}

				// When the drag ends, close the undo group and reset state

				.onEnded
				{
					_ in

					self.undoManager?.setActionName(self.undoName)
					self.undoManager?.endUndoGrouping()

					self.dragIteration = 0
				}
			)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

