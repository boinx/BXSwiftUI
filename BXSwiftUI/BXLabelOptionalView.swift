//**********************************************************************************************************************
//
//  BXLabelOptionalView.swift
//	Adds BXLabelViews + and - buttons to the regular BXLabelView
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXLabelOptionalView<M,V> : View where V:View
{
	private var label:String
	private var width:Binding<CGFloat>? = nil
	private var value:M?
	private var plusAction:()->Void
	private var minusAction:()->Void
	private var content:(M)->V

	@State private var isExpanded = false
	
	private var minWidth:CGFloat
	{
		width?.wrappedValue ?? 0.0
	}

	public init(label:String = "", width:Binding<CGFloat>? = nil, value:M?, plusAction:@escaping ()->Void, minusAction:@escaping ()->Void, @ViewBuilder content:@escaping (M)->V)
	{
		self.label = label
		self.width = width
		self.value = value
		self.plusAction = plusAction
		self.minusAction = minusAction
		self.content = content
	}
	
	public var body: some View
	{
		HStack
		{
			HStack
			{
				// Property label
				
				Text(self.label)

				// "+" button to create value
				
				Text("⊕")
					.font(.body)
					.disabled(self.value == nil)
					.opacity(self.value == nil ? 1.0 : 0.33)
					.onTapGesture
					{
						self.plusAction()
					}

				// "-" button to destroy value
				
				Text("⊖")
					.font(.body)
					.disabled(self.value != nil)
					.opacity(self.value != nil ? 1.0 : 0.33)
					.onTapGesture
					{
						self.minusAction()
					}
			}
			
			// Make sure that we are aligned with other labels
			
			.background( GeometryReader
			{
				Color.clear.preference(
					key:BXLabelViewKey.self,
					value:[BXLabelViewData(width:$0.size.width)])
			})
			.frame(minWidth:self.minWidth, alignment:.leading)

			// Content view or "nil"
			
			if self.value != nil
			{
				self.content(self.value!)
			}
			else
			{
				Text("nil")
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

