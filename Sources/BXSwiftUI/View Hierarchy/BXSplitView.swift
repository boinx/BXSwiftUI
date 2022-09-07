//**********************************************************************************************************************
//
//  BXVSplitView.swift
//	A customizable SplitView implementation that can persist divider position
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import BXSwiftUtils
import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public enum BXSlitViewStyle
{
	case vertical
	case horizontal
}
	
	
//----------------------------------------------------------------------------------------------------------------------


public struct BXSplitView<A:View,B:View,D:View> : View
{
	var style:BXSlitViewStyle = .vertical
	var position:Binding<Double>
	var minFirstSize:CGFloat = 64
	var minSecondSize:CGFloat = 64
	var firstView:()->A
	var secondView:()->B
	var divider:()->D
    
    public init(style:BXSlitViewStyle = .vertical, position:Binding<Double>, minFirstSize:CGFloat = 64, minSecondSize:CGFloat = 64, firstView:@escaping ()->A, secondView:@escaping ()->B, divider:@escaping ()->D)
    {
		self.style = style
        self.position = position
        self.minFirstSize = minFirstSize
		self.minSecondSize = minSecondSize
		self.firstView = firstView
		self.secondView = secondView
		self.divider = divider
   }
    
	public var body: some View
    {
		GeometryReader
		{
			geometry in
			
			if self.style == .vertical
			{
				VStack(spacing:0)
				{
					self.firstView()
						.frame(height:CGFloat(position.wrappedValue))
						
					BXSplitViewDivider(style:style, position:position, geometry:geometry, minFirstSize:minFirstSize, minSecondSize:minSecondSize, divider:divider)
					
					self.secondView()
						.frame(maxHeight:.infinity)
				}
			}
			else
			{
				HStack(spacing:0)
				{
					self.firstView()
						.frame(width:CGFloat(position.wrappedValue))
						
					BXSplitViewDivider(style:style, position:position, geometry:geometry, minFirstSize:minFirstSize, minSecondSize:minSecondSize, divider:divider)
					
					self.secondView()
						.frame(maxWidth:.infinity)
				}
			}
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXSplitViewDivider<D:View>: View
{
	var style:BXSlitViewStyle
    var position:Binding<Double>
    var geometry:GeometryProxy
	var minFirstSize:CGFloat
	var minSecondSize:CGFloat
	var divider:()->D
    
    @State private var initialPosition:Double?

    public init(style:BXSlitViewStyle = .vertical, position:Binding<Double>, geometry:GeometryProxy, minFirstSize:CGFloat = 64, minSecondSize:CGFloat = 64, divider:@escaping ()->D)
    {
		self.style = style
        self.position = position
        self.geometry = geometry
        self.minFirstSize = minFirstSize
		self.minSecondSize = minSecondSize
		self.divider = divider
   }
    
    public var body: some View
    {
		self.divider()
			.cursor(self.cursor, for:[])
            .gesture( DragGesture(minimumDistance:10, coordinateSpace:.global)
            
				.onChanged
				{
					drag in
					
					if initialPosition == nil
					{
						initialPosition = position.wrappedValue
					}
					
					if let initialPosition = initialPosition
					{
						let totalSize = self.style == .vertical ? geometry.size.height : geometry.size.width
						var delta = self.style == .vertical ? drag.translation.height : drag.translation.width
						let minValue = minFirstSize
						let maxValue = totalSize - minSecondSize

						if self.style == .vertical
						{
							if #available(macOS 12, *)
							{
							
							}
							else
							{								// On Big Sur and earlier vertical drags are for some
								delta = -delta				// reason reversed - so the delta needs to be negated
							}								// to account for this problem.
						}
						
						self.position.wrappedValue = Double((initialPosition + delta).clipped(to:minValue...maxValue))
					}
				}
				
				.onEnded
				{
					_ in self.initialPosition = nil
				})
    }
    
    var cursor:NSCursor
    {
		self.style == .vertical ? NSCursor.resizeUpDown : NSCursor.resizeLeftRight
    }
}


//----------------------------------------------------------------------------------------------------------------------


#endif
