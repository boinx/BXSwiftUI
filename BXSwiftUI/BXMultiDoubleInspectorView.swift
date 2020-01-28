//**********************************************************************************************************************
//
//  BXMultiDoubleInspectorView.swift
//	Compound views for inspector style user interfaces
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


/// Inspector view for multiple values of Double

public struct BXMultiDoubleInspectorView: View
{
	public var label:String = ""
	public var width:Binding<CGFloat>? = nil
	public var values:Binding<Set<Double>>
	public var range:ClosedRange<Double> = 0.0...60.0
	public var formatter:Formatter? = nil
	
	public init(label:String = "", width:Binding<CGFloat>? = nil, values:Binding<Set<Double>>, range:ClosedRange<Double>, formatter:Formatter? = nil)
	{
		self.label = label
		self.width = width
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

				BXMultiValueTextField(values:values, height:17, alignment:.trailing, formatter:formatter)
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
			
			BXMultiValueSlider(values:values, in:range)
				.zIndex(-1)
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


//----------------------------------------------------------------------------------------------------------------------


