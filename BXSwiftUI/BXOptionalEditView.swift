//**********************************************************************************************************************
//
//  BXOptionalEditView.swift
//	A view to edit a single Optional property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXOptionalEditView<M,V> : View where V:View
{
	private var label:String
	private var labelWidth:Binding<CGFloat>? = nil
	private var value:M?
	private var createAction:()->Void
	private var destroyAction:()->Void
	private var content:(M)->V

	@State private var isExpanded = false
	
	private var minWidth:CGFloat
	{
		labelWidth?.wrappedValue ?? 0.0
	}

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
		HStack
		{
			HStack
			{
				// Property label
				
				Text(self.label)

				// "+" button to create object
				
				Text("⊕")
					.font(.body)
					.disabled(self.value == nil)
					.opacity(self.value == nil ? 1.0 : 0.33)
					.onTapGesture
					{
						self.createAction()
					}

				// "-" button to destroy object
				
				Text("⊖")
					.font(.body)
					.disabled(self.value != nil)
					.opacity(self.value != nil ? 1.0 : 0.33)
					.onTapGesture
					{
						self.destroyAction()
					}
			}
			
			// Make sure that we are aligned with other labels
			
			.background( GeometryReader
			{
				Color.clear.preference(
					key:PropertyLabelKey.self,
					value:[PropertyLabelData(width:$0.size.width)])
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

