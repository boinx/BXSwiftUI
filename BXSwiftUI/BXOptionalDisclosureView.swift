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
	private var labelWidth:Binding<CGFloat>? = nil
	private var value:M?
	private var createAction:()->Void
	private var destroyAction:()->Void
	private var content:(M)->V
	@State private var isExpanded = false
	
	
	public init(label:String, labelWidth:Binding<CGFloat>? = nil, value:M?, createAction:@escaping ()->Void, destroyAction:@escaping ()->Void, @ViewBuilder content:@escaping (M)->V)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
		self.createAction = createAction
		self.destroyAction = destroyAction
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
							self.createAction()
						}

					// "-" button to destroy value
					
					Text("⊖")
						.font(.body)
						.disabled(self.value != nil)
						.opacity(self.value != nil ? 1.0 : 0.33)
						.onTapGesture
						{
							self.destroyAction()
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
