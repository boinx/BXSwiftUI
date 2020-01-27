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
	private var viewBuilder:(String,Binding<CGFloat>?,M)->V
	
	@State private var isExpanded = false
	
	public init(label:String, labelWidth:Binding<CGFloat>? = nil, value:M?, @ViewBuilder viewBuilder:@escaping (String,Binding<CGFloat>?,M)->V)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
		self.viewBuilder = viewBuilder
	}
	
	public var body: some View
	{
		Group
		{
			// If the optional value is available, then display the view for it
			
			if self.value != nil
			{
				self.viewBuilder(self.label, self.labelWidth, self.value!)
			}
			
			// If not, then just display the label and "nil"
			
			else
			{
				HStack
				{
					BXPropertyLabel(self.label, width:self.labelWidth)
					Text("nil")
					
					Spacer()
					
					Button("Create")
					{
						#warning("TODO: implement")
					}
				}
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

