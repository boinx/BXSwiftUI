//**********************************************************************************************************************
//
//  BXArrayEditView.swift
//	A view to edit a single Array property
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXArrayEditView<M,V> : View where M:Identifiable, V:View
{
	// Params
	
	private var label:String
	private var values:Binding<Array<M>>
	private var rowView:(M)->V
	
	// State
	
	@State private var isExpanded = false
	
	// Init
	
	public init(label:String = "", values:Binding<Array<M>>, @ViewBuilder rowView:@escaping (M)->V)
	{
		self.label = label
		self.values = values
		self.rowView = rowView
	}
	
	// Build View
	
	public var body: some View
	{
		BXDisclosureView(isExpanded:$isExpanded,

			header:
			{
				HStack
				{
					BXDisclosureButton(self.label, isExpanded:self.$isExpanded)
					Spacer()
				}
			},
				
			body:
			{
				Text("Placeholder")
//				ForEach(self.values.wrappedValue)
//				{
//					self.rowView($0)
//				}
			})
	}
}


//----------------------------------------------------------------------------------------------------------------------

