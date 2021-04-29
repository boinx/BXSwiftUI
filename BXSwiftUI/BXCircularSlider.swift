//**********************************************************************************************************************
//
//  BXCircularSlider.swift
//	A circular slider for SwiftUI
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXCircularSlider : View
{
	// Params
	
	private var value:Binding<Double>
	private var range:ClosedRange<Double>
	private var radius:CGFloat = 16.0
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil

	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxColorTheme) private var bxColorTheme
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// State
	
	@State private var dragIteration = 0

	// Init
	
	public init(value:Binding<Double>, range:ClosedRange<Double> = 0.0...360.0, radius:CGFloat = 15.0, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.value = value
		self.range = range
		self.radius = radius
		self.onBegan = onBegan
		self.onEnded = onEnded
	}
	
	// Build the view
	
	public var body: some View
	{
		ZStack
		{
			Circle()
				.fill(bxColorTheme.fillColor(for:colorScheme))
				
			Circle()
				.stroke(bxColorTheme.strokeColor(for:colorScheme), lineWidth:0.6)

			_Arrow()
				.fill(bxColorTheme.contentColor(for:colorScheme))
				.rotationEffect(.degrees(degrees(for:self.value.wrappedValue, in:self.range)))

			Circle()
				.fill(Color(white:0.0, opacity:0.01))
				.gesture( DragGesture(minimumDistance:0)
				
					.onChanged()
					{
						// On mouse down begin an undo group
						
						if self.dragIteration == 0
						{
							self.undoManager?.beginUndoGrouping()
							self.onBegan?()
						}
						
						self.dragIteration += 1
						
						// On drag set new value

						self.value.wrappedValue = degrees(for:$0.location, in:self.radius)
					}
					.onEnded()
					{
						_ in
						
						// On mouse up close undo group
						
						self.onEnded?()
						self.undoManager?.setActionName(self.undoName)
						self.undoManager?.endUndoGrouping()
						self.dragIteration = 0
					}
				)
		}
		.frame(width:2*radius, height:2*radius)
		.compositingGroup()
		.reducedOpacityWhenDisabled()
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXMultiValueCircularSlider : View
{
	// Params
	
	private var values:Binding<Set<Double>>
	private var range:ClosedRange<Double>
	private var radius:CGFloat = 16.0
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil

	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxColorTheme) private var bxColorTheme
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// State
	
	@State private var dragIteration = 0

	// Init
	
	public init(values:Binding<Set<Double>>, range:ClosedRange<Double> = 0.0...360.0, radius:CGFloat = 15.0, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.values = values
		self.range = range
		self.radius = radius
		self.onBegan = onBegan
		self.onEnded = onEnded
	}
	
	// Build the view
	
	public var body: some View
	{
		ZStack
		{
			Circle()
				.fill(bxColorTheme.fillColor(for:colorScheme))

			Circle()
				.stroke(bxColorTheme.strokeColor(for:colorScheme), lineWidth:0.6)
				
			ForEach(Array(self.values.wrappedValue), id:\.self)
			{
				_Arrow()
					.fill(self.bxColorTheme.contentColor(for:self.colorScheme))
					.rotationEffect(.degrees(degrees(for:$0, in:self.range)))
			}

			Circle()
				.fill(Color(white:0.0, opacity:0.01))
				.gesture( DragGesture(minimumDistance:0)
				
					.onChanged()
					{
						// On mouse down begin an undo group
						
						if self.dragIteration == 0
						{
							self.undoManager?.beginUndoGrouping()
							self.onBegan?()
						}
						
						self.dragIteration += 1
						
						// On drag set new value
						
						let value = degrees(for:$0.location, in:self.radius)
						self.values.wrappedValue = Set([value])
						
						// Make sure that async work gets executed
						
						DispatchQueue.main.executeScheduledBlocks()
					}
					.onEnded()
					{
						_ in
						
						// On mouse up close undo group
						
						self.onEnded?()
						self.undoManager?.setActionName(self.undoName)
						self.undoManager?.endUndoGrouping()
						self.dragIteration = 0
					}
				)
		}
		.frame(width:2*radius, height:2*radius)
		.compositingGroup()
		.reducedOpacityWhenDisabled()
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: - Helpers

/// Draws an arrow pointing up (0°)

fileprivate struct _Arrow : Shape
{
    func path(in rect: CGRect) -> Path
    {
		let x0 = rect.midX
		let y0 = rect.minY
		let h = CGFloat(9.0)
		let w = CGFloat(3.0)

        var path = Path()
		path.move(to: CGPoint(x:x0, y:y0))
		path.addLine(to: CGPoint(x:x0+w, y:y0+h))
		path.addLine(to: CGPoint(x:x0-w, y:y0+h))
		path.closeSubpath()
		
		return path
    }
}


//----------------------------------------------------------------------------------------------------------------------


// Convert between angle (in degrees) and the value in the native range.
// Please note that these are identical for the default range of 0.0...360.0

fileprivate func degrees(for value:Double, in range:ClosedRange<Double>) -> Double
{
	let v1 = range.lowerBound
	let v2 = range.upperBound
	let fraction = (value-v1) / (v2 - v1)

	return fraction * 360.0
}

fileprivate func value(for degrees:Double, in range:ClosedRange<Double>) -> Double
{
	let v1 = range.lowerBound
	let v2 = range.upperBound
	let fraction = degrees / 360.0

	return v1 + fraction * (v2 - v1)
}


// Calculate the angle in degrees for a location inside a view of specified size

fileprivate func degrees(for location:CGPoint, in radius:CGFloat) -> Double
{
	let rx = Double(location.x - radius)
	let ry = Double(location.y - radius)
	let radians = atan2(ry,rx)
	
	var degrees = radians * 180.0 / Double.pi + 90.0
	while degrees < 0.0 { degrees += 360.0 }
	while degrees > 360.0 { degrees -= 360.0 }
	
	if BXModifierKeys.shared.flags.contains(.shift)
	{
		degrees = round(degrees / 45.0) * 45.0
	}
	
	return degrees
}


//----------------------------------------------------------------------------------------------------------------------

