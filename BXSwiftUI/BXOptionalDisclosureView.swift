//**********************************************************************************************************************
//
//  BXOptionalDisclosureView.swift
//	Disclosure view for an optional object of type M
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXOptionalDisclosureView<M,V> : View where V:View
{
	private var label:String
	private var width:Binding<CGFloat>? = nil
	private var value:M?
	private var plusAction:()->Void
	private var minusAction:()->Void
	private var content:(M)->V
	@State private var isExpanded = false
	
	
	public init(label:String, width:Binding<CGFloat>? = nil, value:M?, plusAction:@escaping ()->Void, minusAction:@escaping ()->Void, @ViewBuilder content:@escaping (M)->V)
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
		BXDisclosureView(isExpanded:self.$isExpanded,
		
			header:
			{
				HStack
				{
					// Disclosure triangle and name
					
					BXDisclosureButton(self.label, isExpanded:self.$isExpanded)

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
			},
			
			body:
			{
				BXIndentationView
				{
					// Display content if the value is available
					
					if self.value != nil
					{
						self.content(self.value!)
					}
					
					// Display "nil" if the value is not available

					else
					{
						Text("nil")
					}
				}
			})
	}
}


//----------------------------------------------------------------------------------------------------------------------
