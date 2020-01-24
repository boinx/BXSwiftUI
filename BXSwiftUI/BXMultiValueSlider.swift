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
    @Binding var values:Set<Double>
	public var `in`:ClosedRange<Double>
	
    func makeNSView(context:Context) -> NSSlider
    {
        let slider = NSSlider(frame:.zero)
        slider.cell = NSMultiValueSliderCell()
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
		
		slider.isEnabled = self.values.count > 0
    }
    
    class Coordinator : NSObject,NSTextFieldDelegate
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
		let rect = knobRect.insetBy(dx:4.0, dy:4.0)
		let path = NSBezierPath(ovalIn:rect)
		path.lineWidth = 1.5
		
		NSGraphicsContext.saveGraphicsState()
		NSGraphicsContext.current?.compositingOperation = .copy
		NSColor.clear.set()
		path.fill()
		NSGraphicsContext.restoreGraphicsState()
		
		NSColor.white.set()
		path.stroke()
	}
}


//----------------------------------------------------------------------------------------------------------------------


struct MultiValueSlider_Previews: PreviewProvider
{
    static var previews: some View
    {
		BXMultiValueSlider(values:Binding.constant(Set([5.0,10.0,20.0])), in:0.0 ... 60.0)
    }
}


//----------------------------------------------------------------------------------------------------------------------
