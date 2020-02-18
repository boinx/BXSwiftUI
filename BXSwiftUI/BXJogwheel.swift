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
	
	private var fillGradient : LinearGradient
	{
		let alpha = isEnabled ? 0.15 : 0.05
		
		let colors:[Color] =
		[
			Color(white:0.0,opacity:alpha),
			Color(white:0.9,opacity:alpha),
			Color(white:1.0,opacity:alpha),
			Color(white:0.9,opacity:alpha),
			Color(white:0.0,opacity:alpha),
		]

		return LinearGradient(gradient: Gradient(colors:colors), startPoint:.leading, endPoint:.trailing)
	}

	private var strokeColor : Color
	{
		let gray = colorScheme == .dark ? 0.65 : 0.35
		let alpha = isEnabled ? 1.0 : 0.33
		return Color(white:gray,opacity:alpha)
	}

	private var tickmarkColor : Color
	{
		let gray = colorScheme == .dark ? 0.65 : 0.35
		let alpha = isEnabled ? 0.4 : 0.12
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
		
		ZStack
		{
			Rectangle()
				.fill(self.fillGradient)
				.border(self.strokeColor, width:0.5)
			
			BXJogwheelLines(value:self.value.wrappedValue)
				.fill(self.tickmarkColor)
		}
		
		// Dim when disabled
		
		.reducedOpacityWhenDisabled()
		
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


struct BXJogwheelLines: Shape
{
	var value:Double = 0.0
	
    func path(in rect:CGRect) -> Path
    {
        var path = Path()
		let n = 30
		
		for i in 0...n
		{
			let radians = 2*Double.pi * Double(i)/Double(n) - value
			let x = cos(radians)
			let y = sin(radians)
			
			let dx = rect.width * CGFloat(x+1.0)*0.5
			let dy = CGFloat(2.0)
			let w = CGFloat(y)
			let h = rect.height - 4.0
			
			if y > 0.0
			{
				 path.addRect(CGRect(x:dx, y:dy, width:w, height:h))
			}
		}

        return path
    }
}


//----------------------------------------------------------------------------------------------------------------------
