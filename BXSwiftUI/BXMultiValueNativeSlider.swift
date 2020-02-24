//**********************************************************************************************************************
//
//  BXMultiValueNativeSlider.swift
//	SwiftUI wrapper for a NSSlider that supports multiple values
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public struct BXMultiValueNativeSlider : NSViewRepresentable
{
	// Params
	
	private var values:Binding<Set<Double>>
	private var range:ClosedRange<Double> = 0.0...1.0
	private var response:BXSliderResponse = .linear
	private var initialAction:(()->Void)? = nil
	
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName

	// Init
	
	public init(values:Binding<Set<Double>>, in range:ClosedRange<Double> = 0.0...1.0, response:BXSliderResponse = .linear, initialAction:(()->Void)? = nil)
	{
		self.values = values
		self.range = range
		self.response = response
		self.initialAction = initialAction
	}
	

	public func makeNSView(context:Context) -> NSSlider
    {
		let cell = NSMultiValueSliderCell()
		cell.undoManager = undoManager
		cell.undoName = undoName
		cell.response = self.response
		
        let slider = NSSlider(frame:.zero)
        slider.cell = cell
		slider.target = context.coordinator
		slider.action = #selector(Coordinator.updateValues(with:))
		
		if self.response.reversed
		{
			slider.minValue = self.response.modelToView(range.upperBound)
			slider.maxValue = self.response.modelToView(range.lowerBound)
		}
		else
		{
			slider.minValue = self.response.modelToView(range.lowerBound)
			slider.maxValue = self.response.modelToView(range.upperBound)
		}
		
		slider.doubleValue = slider.minValue

		return slider
    }


	public func updateNSView(_ slider:NSSlider, context:Context)
    {
		(slider.cell as? NSMultiValueSliderCell)?.values = self.values.wrappedValue
		
		if let value = values.wrappedValue.first
		{
			slider.doubleValue = slider.minValue - 1.0
			slider.doubleValue = self.response.modelToView(value)
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
        var slider:BXMultiValueNativeSlider
		var response:BXSliderResponse
		
        init(_ slider:BXMultiValueNativeSlider,_ response:BXSliderResponse)
        {
            self.slider = slider
            self.response = response
         }

        @objc func updateValues(with sender:NSSlider)
        {
			let viewValue = sender.doubleValue
			let modelValue = self.response.viewToModel(viewValue)
			
			self.slider.initialAction?()
			self.slider.values.wrappedValue = Set([modelValue])
        }
    }
    
	public func makeCoordinator() -> Coordinator
    {
        return Coordinator(self, self.response)
    }
}


//----------------------------------------------------------------------------------------------------------------------


class NSMultiValueSliderCell : NSSliderCell
{
	public var values = Set<Double>()
	public var response:BXSliderResponse = .linear
	public var undoManager:UndoManager?
	public var undoName:String = ""

    override open func drawBar(inside rect:NSRect, flipped:Bool)
    {
		let savedValue = self.doubleValue
		defer { self.doubleValue = savedValue }
		
		let value = self.values.max() ?? self.minValue
		self.doubleValue = self.response.modelToView(value)
		super.drawBar(inside:rect, flipped:flipped)
	}

	override func drawKnob()
	{
		let savedValue = self.doubleValue
		defer { self.doubleValue = savedValue }
		
		for value in self.values.sorted()
		{
			self.doubleValue = self.response.modelToView(value)
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