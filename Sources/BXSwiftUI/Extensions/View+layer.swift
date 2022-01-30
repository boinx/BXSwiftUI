//**********************************************************************************************************************
//
//  View+layer.swift
//	Add layers on top of a view
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Adds a layer (overlay) on top of the View.
	/// - parameter alignment: The alignment for the new layer
	/// - parameter layer: The layer to be added on top of this view
	
	func layer<Layer:View>(alignment:Alignment = .topLeading, @ViewBuilder layer:()->Layer) -> some View
	{
		self.overlay(layer(), alignment:alignment)
	}
	
	
	/// Adds a layer that is dependant on a model object on top of the View.
	/// - parameter object: The model object
	/// - parameter alignment: The alignment for the new layer
	/// - parameter layer: The layer to be added on top of this view
	
	func layer<Model:Identifiable,Layer:View>(_ object:Model, alignment:Alignment = .topLeading, @ViewBuilder layer:(Model)->Layer) -> some View
	{
		self.overlay(layer(object), alignment:alignment)
	}
	

	/// Adds mulitple layers that are dependant on a model object on top of the View.
	/// - parameter objects: The array of model objects
	/// - parameter alignment: The alignment for the new layers
	/// - parameter layer: The layer to be added on top of this view
	
	func layers<Model:Identifiable,Layer:View>(_ objects:[Model], alignment:Alignment = .topLeading, @ViewBuilder layer:@escaping (Model)->Layer) -> some View
	{
		// IMPORTANT

		// By itself ZStack is very expensive when calculating layout, because it queries the sizes and positions of
		// all its children before deciding on its own size. This can cause immense CPU workload for large numbers
		// of children. However when enclosing the ZStack in an overlay of a existing parent view, then the size of
		// the ZStack seems to be identical to the parent view and all this layout calculation is skipped, thus saving
		// a lot of CPU time.
		
		self.overlay(
		
			ZStack
			{
				ForEach(objects)
				{
					layer($0)
				}
			},
			
			alignment:alignment
		)
	}
}


//----------------------------------------------------------------------------------------------------------------------

