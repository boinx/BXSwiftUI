//**********************************************************************************************************************
//
//  BXJogwheel.swift
//	A custom slider
//  Copyright ©2020-2025 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


public struct BXJogwheel : View
{
	// Params
	
	private var value:Binding<Double>
	private var speed:Double
	private var commandKeyFactor = 1.0
	private var optionKeyFactor = 1.0
	private var controlKeyFactor = 1.0
	private var shiftKeyFactor = 1.0

	private var stepperBinding:Binding<Double>?
	private var stepperDelta:Double = 0.1
	
	private var onBegan:(()->Void)? = nil
	private var onChanged:((Double,Double)->Void)? = nil
	private var onEnded:(()->Void)? = nil
	
	// Environment
	
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxUndoManagerProvider) private var undoManagerProvider
	@Environment(\.bxUndoName) private var undoName

	// Init
	
	public init(value:Binding<Double>, speed:Double = 1.0, commandKeyFactor:Double = 1.0, optionKeyFactor:Double = 1.0, controlKeyFactor:Double = 1.0, shiftKeyFactor:Double = 1.0, stepperBinding:Binding<Double>? = nil, stepperDelta:Double = 0.1, onBegan:(()->Void)? = nil, onChanged:((Double,Double)->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.value = value
		self.speed = speed
		self.commandKeyFactor = commandKeyFactor
		self.optionKeyFactor = optionKeyFactor
		self.controlKeyFactor = controlKeyFactor
		self.shiftKeyFactor = shiftKeyFactor
		
		self.stepperBinding = stepperBinding
		self.stepperDelta = stepperDelta
		
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
	
	@State private var lastLocation:CGPoint = .zero
	@State private var undoHelper = BXUndoGroupingHelper()
	
	@EnvironmentObject var modifierKeys:BXModifierKeys


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
			
			BXJogwheelLines(value:self.value.wrappedValue, speed:speed, speedFactor:speedModifier)
				.fill(self.tickmarkColor)
			
			if let stepperBinding = self.stepperBinding
			{
				HStack
				{
					BXJogwheelStepper()
					{
						stepperBinding.wrappedValue -= stepperDelta
					}
					.cursor(.minus, for:[])
						
					Spacer()
					
					BXJogwheelStepper()
					{
						stepperBinding.wrappedValue += stepperDelta
					}
					.cursor(.plus, for:[])
				}
			}
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
					
					self.lastLocation = $0.startLocation
				}
				
				// Update the current value

				let dx = $0.location.x - self.lastLocation.x	// Mouse delta since last iteration
				self.lastLocation = $0.location

				var delta = dx
				delta *= speed									// Speed configuration of this particual jogwheel
				delta *= speedModifier							// Option key slows down the speed

				let value = self.value.wrappedValue + delta
				self.value.wrappedValue = value

				// Call the onChanged action with current value and delta
				
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


	/// The speed is multiplied by this factor, which depends on the currently pressed modifier keys
	
	var speedModifier:CGFloat
	{
		let flags = BXModifierKeys.shared.currentFlags
		
		if flags.contains(.command)
		{
			return self.commandKeyFactor
		}
		else if flags.contains(.option)
		{
			return self.optionKeyFactor
		}
		else if flags.contains(.control)
		{
			return self.controlKeyFactor
		}
		else if flags.contains(.shift)
		{
			return self.shiftKeyFactor
		}
		
		return 1.0
	}
}


//----------------------------------------------------------------------------------------------------------------------


struct BXJogwheelLines : Shape
{
	var value = 0.0
	var speed = 0.015
	var speedFactor:CGFloat = 1.0
	
	@EnvironmentObject var modifierKeys:BXModifierKeys
	
    func path(in rect:CGRect) -> Path
    {
		let f = 0.015 / speed
		let v = f * value
		
        var path = Path()
		var n = 30
		if speedFactor < 1.0 { n *= 2 }
		
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


/// The stepper is an invisible click area at both ends of a BXJogWheel that supports stepping up or down with single clicks

public struct BXJogwheelStepper : View
{
	public var action:()->Void
	
	public var body: some View
	{
		Rectangle()
			.fill(.clear)
			.frame(width:8)
			
			.contentShape(Rectangle())
			.onTapGesture
			{
				action()
			}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
