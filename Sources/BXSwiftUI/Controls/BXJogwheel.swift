//**********************************************************************************************************************
//
//  BXJogwheel.swift
//	A custom slider
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


public struct BXJogwheel : View
{
	// Params
	
	private var value:Binding<Double>
	private var speed:Double
	private var onBegan:(()->Void)? = nil
	private var onChanged:((Double,Double)->Void)? = nil
	private var onEnded:(()->Void)? = nil
	
	// Environment
	
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxUndoManagerProvider) private var undoManagerProvider
	@Environment(\.bxUndoName) private var undoName

	// Init
	
	public init(value:Binding<Double>, speed:Double = 1.0, onBegan:(()->Void)? = nil, onChanged:((Double,Double)->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.value = value
		self.speed = speed
		self.onBegan = onBegan
		self.onChanged = onChanged
		self.onEnded = onEnded
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Appearance
	
	private var fillGradient : LinearGradient
	{
		let alpha = 0.15
		
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
		let gray = colorScheme == .dark ? 0.65 : 0.20
		return Color(white:gray, opacity:1.0)
	}

	private var tickmarkColor : Color
	{
		let gray = colorScheme == .dark ? 0.55 : 0.35
		return Color(white:gray, opacity:0.8)
	}


//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Event Handling
	
	// Counts up each time we go through the onChanged handler of the DragGesture
	
	@GestureState private var dragIteration = 0
	
	@State private var dragInitialValue:Double = 0.0
	@State private var prevX:CGFloat = 0.0
	@State private var undoHelper = BXUndoGroupingHelper()
	

//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Build View
	
	public var body: some View
	{
		// Draw the jogwheel
		
		ZStack
		{
			Rectangle()
				.fill(self.fillGradient)
				.border(self.strokeColor, width:1)
			
			BXJogwheelLines(value:self.value.wrappedValue, speed:speed)
				.fill(self.tickmarkColor)
		}
		
		// Dim when disabled
		
		.reducedOpacityWhenDisabled()
		
		// Event handling

		.gesture( DragGesture(minimumDistance:0.0)

			.updating($dragIteration)
			{
				_,iteration,_ in iteration += 1
			}

			.onChanged()
			{
				if dragIteration <= 1
				{
					// When dragging starts open an undo group
					
					self.undoHelper.undoManager = self.undoManagerProvider.undoManager
					self.undoHelper.beginUndoGrouping()
					self.onBegan?()

					// Store initial value
					
					self.dragInitialValue = self.value.wrappedValue
				}
				
				// Update the current value

				let dx = $0.translation.width
				let value = self.dragInitialValue + self.speed * Double(dx)
				self.value.wrappedValue = value
				
				// Call the onChanged action with current value and delta
				
				let x = $0.location.x
				let delta = self.speed * Double(x - self.prevX)
				self.prevX = x
				self.onChanged?(value,delta)
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


//----------------------------------------------------------------------------------------------------------------------


struct BXJogwheelLines : Shape
{
	var value = 0.0
	var speed = 0.015
	
    func path(in rect:CGRect) -> Path
    {
		let f = 0.015 / speed
		let v = f * value
		
        var path = Path()
		let n = 30
		
		for i in 0...n
		{
			let radians = 2*Double.pi * Double(i)/Double(n) - v
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
