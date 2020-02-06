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


public struct BXMultiValueSlider : NSViewRepresentable
{
	// Params
	
	private var values:Binding<Set<Double>>
	private var range:ClosedRange<Double> = 0.0...1.0
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// Init
	
	public init(values:Binding<Set<Double>>, in range:ClosedRange<Double> = 0.0...1.0)
	{
		self.values = values
		self.range = range
	}
	

	public func makeNSView(context:Context) -> NSSlider
    {
		let cell = NSMultiValueSliderCell()
		cell.undoManager = undoManager
		cell.undoName = undoName
		
        let slider = NSSlider(frame:.zero)
        slider.cell = cell
		slider.target = context.coordinator
		slider.action = #selector(Coordinator.updateValues(with:))
		slider.doubleValue = range.lowerBound
		slider.minValue = range.lowerBound
		slider.maxValue = range.upperBound
		
		return slider
    }


	public func updateNSView(_ slider:NSSlider, context:Context)
    {
		(slider.cell as? NSMultiValueSliderCell)?.values = self.values.wrappedValue
		
		if let value = values.wrappedValue.first
		{
			slider.doubleValue = slider.minValue - 1.0
			slider.doubleValue = value
		}
		else
		{
			slider.doubleValue = slider.minValue - 1.0
			slider.doubleValue = slider.minValue
		}
		
		slider.isEnabled = self.isEnabled && self.values.wrappedValue.count > 0
    }
    
    
	public class Coordinator : NSObject
    {
        var slider:BXMultiValueSlider

        init(_ slider:BXMultiValueSlider)
        {
            self.slider = slider
        }

        @objc func updateValues(with sender:NSSlider)
        {
			slider.values.wrappedValue = Set([sender.doubleValue])
        }
    }
    
	public func makeCoordinator() -> Coordinator
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
		
		let appearance = self.controlView?.appearance?.name ?? NSAppearance.Name.darkAqua
		let gray:CGFloat = appearance == NSAppearance.Name.darkAqua ? 1.0 : 0.35
		let alpha:CGFloat = isEnabled ? 1.0 : 0.33
		NSColor(white:gray, alpha:alpha).set()
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
