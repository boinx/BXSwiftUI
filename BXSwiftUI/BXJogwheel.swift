//**********************************************************************************************************************
//
//  BXJogwheel.swift
//	A custom slider
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXJogwheel : View
{
	// Params
	
	private var value:Binding<Double>
	private var speed:Double
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// Init
	
	public init(value:Binding<Double>, speed:Double = 1.0)
	{
		self.value = value
		self.speed = speed
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Appearance
	
	private var fillColor : Color
	{
		let alpha = isEnabled ? 1.0 : 0.33
		return colorScheme == .dark ? Color(white:1.0,opacity:0.15*alpha) : Color(white:0.0,opacity:0.15*alpha)
	}

	private var strokeColor : Color
	{
		let gray = colorScheme == .dark ? 0.65 : 0.35
		let alpha = isEnabled ? 1.0 : 0.33
		return Color(white:gray,opacity:alpha)
	}


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Event Handling
	
	// Counts up each time we go through the onChanged handler of the DragGesture
	
	@State private var dragIteration = 0
	@State private var dragInitialPosition:CGFloat = 0.0
	@State private var dragInitialValue:Double = 0.0


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Build View
	
	public var body: some View
	{
		// Draw the jogwheel
		
		Rectangle()
			.fill(self.fillColor)
			.border(self.strokeColor, width:0.5)

		// Event handling

		.gesture( DragGesture(minimumDistance:0.0)

			.onChanged()
			{
				// When dragging starts, open an undo group and store intial state

				if self.dragIteration == 0
				{
					self.undoManager?.beginUndoGrouping()

					self.dragInitialPosition = $0.location.x
					self.dragInitialValue = self.value.wrappedValue
				}

				// Update the current value

				let dx = $0.location.x - self.dragInitialPosition
				let delta = self.speed * Double(dx)
				self.value.wrappedValue = self.dragInitialValue + delta
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


//----------------------------------------------------------------------------------------------------------------------

