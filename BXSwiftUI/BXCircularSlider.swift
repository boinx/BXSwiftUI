//**********************************************************************************************************************
//
//  BXCircularSlider.swift
//	A circular slider for SwiftUI
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXCircularSlider : View
{
	private var radius:CGFloat = 15.0
	private var value:Binding<Double>

	public init(radius:CGFloat = 15.0, value:Binding<Double>)
	{
		self.radius = radius
		self.value = value
	}
	
	public var body: some View
	{
		ZStack
		{
			Circle()
				.fill(Color(white:1.0, opacity:0.1))
				
			Circle()
				.stroke(Color.white, lineWidth:0.5)

			Arrow()
				.fill(Color.white)
				.rotationEffect(.degrees(value.wrappedValue))
		}
		
		.gesture( DragGesture(minimumDistance:0)
		.onChanged(
		{
			value in

			self.value.wrappedValue = Double(value.location.y / 2*self.radius)
		}))
	}
}


//----------------------------------------------------------------------------------------------------------------------


struct Arrow : Shape
{

    func path(in rect: CGRect) -> Path
    {
		let x0 = rect.midX
		let y0 = rect.minY
		let h = CGFloat(9.0)
		let w = CGFloat(3.0)

        var path = Path()
		path.move(to: CGPoint(x:x0, y:y0))
		path.addLine(to: CGPoint(x:x0+w, y:y0+h))
		path.addLine(to: CGPoint(x:x0-w, y:y0+h))
		path.closeSubpath()
		
		return path
    }
}


//----------------------------------------------------------------------------------------------------------------------

