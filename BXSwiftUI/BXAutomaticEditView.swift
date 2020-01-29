//**********************************************************************************************************************
//
//  BXAutomaticEditView.swift
//	An automatically generated editor view for type T
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


public struct BXAutomaticEditView<T> : View where T:ObservableObject
{
	public var labelWidth:Binding<CGFloat>? = nil
	@ObservedObject public var value:T
	
	private var mirror:Mirror
	private var properties:[Property] = []
	
	struct Property : Identifiable
	{
		var name:String
		var value:Any
		var id = UUID().uuidString
	}
	
	public init(labelWidth:Binding<CGFloat>? = nil, value:T)
	{
		self.labelWidth = labelWidth
		self.value = value
		
		self.mirror = Mirror.init(reflecting:value)
		
		for child in mirror.children
		{
			let name = child.label ?? "unknown"
			self.properties += Property(name:name, value:child.value)
			
			print("Property name:", child.label)
			print("Property value:", child.value)
		}
	}
	
	public var body: some View
	{
		Group
		{
			ForEach(self.properties)
			{
				BXLabelView(label:$0.name, width:self.labelWidth)
				{
					Text("Placeholder")
				}
			}
		}
		
	}
}


//----------------------------------------------------------------------------------------------------------------------

