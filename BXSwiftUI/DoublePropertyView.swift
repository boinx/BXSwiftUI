//**********************************************************************************************************************
//
//  DoublePropertyView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Property view for a single value Double

public struct DoublePropertyView: View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>? = nil
	public var value:Binding<Double>
	public var range:ClosedRange<Double> = 0.0...60.0
	public var formatter:Formatter? = nil
	
	public init(label:String = "", labelWidth:Binding<CGFloat>? = nil, value:Binding<Double>, range:ClosedRange<Double> = 0.0...60.0, formatter:Formatter? = nil)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
		self.range = range
		self.formatter = formatter
	}
	
    public var body: some View
    {
		return VStack(alignment:.leading, spacing:-10.0)
		{
			HStack
			{
				Text(label)

				Spacer()

				CustomTextField(value:value, height:17, alignment:.trailing, formatter:formatter)
				{
					(nstextfield,isFirstResponder,isHovering) in
					let isActive = isFirstResponder || isHovering
					nstextfield.isBordered = false
					nstextfield.drawsBackground = isActive
					nstextfield.layer?.borderWidth = isActive ? 1.0 : 0.0
					nstextfield.layer?.borderColor = NSColor.lightGray.cgColor
				}
				.frame(width:60.0)
				.offset(x:0,y:1)
			}
			
			Slider(value:value, in:range)
				.zIndex(-1)
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


/// Property view for multiple values of Double

public struct MultiDoublePropertyView: View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>? = nil
	public var values:Binding<Set<Double>>
	public var range:ClosedRange<Double> = 0.0...60.0
	public var formatter:Formatter? = nil
	
	public init(label:String = "", labelWidth:Binding<CGFloat>? = nil, values:Binding<Set<Double>>, range:ClosedRange<Double>, formatter:Formatter? = nil)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.values = values
		self.range = range
		self.formatter = formatter
	}
	
	private var value:Double
	{
		return values.wrappedValue.first ?? 0.0
	}
	
    public var body: some View
    {
		return VStack(alignment:.leading, spacing:-2.0)
		{
			HStack
			{
				Text(label)

				Spacer()

				MultiValueTextField(values:values, height:17, alignment:.trailing, formatter:formatter)
				{
					(nstextfield,isFirstResponder,isHovering) in
					let isActive = isFirstResponder || isHovering
					nstextfield.isBordered = false
					nstextfield.drawsBackground = isActive
					nstextfield.layer?.borderWidth = isActive ? 1.0 : 0.0
					nstextfield.layer?.borderColor = NSColor.lightGray.cgColor
				}
				.frame(width:60.0)
				.offset(x:0,y:1)
			}
			
			MultiValueSlider(values:values, in:range)
				.zIndex(-1)
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


//----------------------------------------------------------------------------------------------------------------------


