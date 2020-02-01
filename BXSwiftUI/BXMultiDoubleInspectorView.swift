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
	
	@Environment(\.isEnabled) private var isEnabled
	
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
					.opacity(isEnabled ? 1.0 : 0.33)

				Spacer()

				BXMultiValueTextField(values:values, alignment:.trailing, formatter:formatter)
				{
					(nsTextField,isFirstResponder,isHovering) in
					let isActive = isFirstResponder || isHovering
					nsTextField.isBordered = false
					nsTextField.drawsBackground = isActive
					nsTextField.layer?.borderWidth = isActive ? 1.0 : 0.0
					nsTextField.layer?.borderColor = NSColor.lightGray.cgColor
				}
				.frame(width:60.0)
			}
			
			BXMultiValueSlider(values:values, in:range)
				.zIndex(-1)
				.offset(x:0,y:1)
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


//----------------------------------------------------------------------------------------------------------------------


