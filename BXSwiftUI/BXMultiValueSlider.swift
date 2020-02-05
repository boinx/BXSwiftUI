//**********************************************************************************************************************
//
//  BXMultiValueSlider.swift
//	SwiftUI wrapper for a NSSlider that supports multiple values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


struct BXMultiValueSlider : NSViewRepresentable
{
	// Params
	
    @Binding public var values:Set<Double>
	public var `in`:ClosedRange<Double>
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	
    func makeNSView(context:Context) -> NSSlider
    {
		let cell = NSMultiValueSliderCell()
		cell.undoManager = undoManager
		cell.undoName = undoName
		
        let slider = NSSlider(frame:.zero)
        slider.cell = cell
		slider.target = context.coordinator
		slider.action = #selector(Coordinator.updateValues(with:))
		slider.doubleValue = `in`.lowerBound
		slider.minValue = `in`.lowerBound
		slider.maxValue = `in`.upperBound
		
		return slider
    }


    func updateNSView(_ slider:NSSlider, context:Context)
    {
		(slider.cell as? NSMultiValueSliderCell)?.values = self.values
		
		if let value = values.first
		{
			slider.doubleValue = slider.minValue - 1.0
			slider.doubleValue = value
		}
		else
		{
			slider.doubleValue = slider.minValue - 1.0
			slider.doubleValue = slider.minValue
		}
		
		slider.isEnabled = self.isEnabled && self.values.count > 0
    }
    
    
    class Coordinator : NSObject
    {
        var slider:BXMultiValueSlider

        init(_ slider:BXMultiValueSlider)
        {
            self.slider = slider
        }

        @objc func updateValues(with sender:NSSlider)
        {
			slider.values = Set([sender.doubleValue])
        }
    }
    
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
}


//----------------------------------------------------------------------------------------------------------------------


class NSMultiValueSliderCell : NSSliderCell
{
	public var values = Set<Double>()
	public var undoManager:UndoManager?
	public var undoName:String = ""

    override open func drawBar(inside rect:NSRect, flipped:Bool)
    {
		let savedValue = self.doubleValue
		defer { self.doubleValue = savedValue }
		
		self.doubleValue = self.values.max() ?? self.minValue
		super.drawBar(inside:rect, flipped:flipped)
	}

	override func drawKnob()
	{
		let savedValue = self.doubleValue
		defer { self.doubleValue = savedValue }
		
		for value in self.values.sorted()
		{
			self.doubleValue = value
			super.drawKnob()
		}
	}

	override open func drawKnob(_ knobRect:NSRect)
	{
		let x:CGFloat = knobRect.midX
		let y:CGFloat = knobRect.midY
		let w:CGFloat = 12.0
		let h:CGFloat = 12.0
		let rect = CGRect(x:x-0.5*w,y:y-0.5*h,width:w,height:h)
		let path = NSBezierPath(ovalIn:rect)
		path.lineWidth = 1.5
		
		NSGraphicsContext.saveGraphicsState()
		NSGraphicsContext.current?.compositingOperation = .copy
		NSColor.clear.set()
		path.fill()
		
		NSColor(white:1.0, alpha:isEnabled ? 1.0 : 0.33).set()
		path.stroke()

		NSGraphicsContext.restoreGraphicsState()
	}
	
	override open func stopTracking(last:NSPoint, current:NSPoint, in view:NSView, mouseIsUp:Bool)
	{
		super.stopTracking(last:last, current:current, in:view, mouseIsUp:mouseIsUp)
		self.undoManager?.setActionName(undoName)
	}

}


//----------------------------------------------------------------------------------------------------------------------
