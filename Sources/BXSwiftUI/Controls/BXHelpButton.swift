//**********************************************************************************************************************
//
//  BXHelpButton.swift
//	A cirular button with a help icon
//  Copyright ©2024 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXHelpButton : View
{
	// Params
	
	private var action:()->Void

	// Environment
	
	@Environment(\.controlSize) private var controlSize
	@Environment(\.isEnabled) private var isEnabled
	
	// Init
	
	public init(action:@escaping ()->Void)
	{
		self.action = action
	}
	
	// Build View
	
	public var body: some View
	{
		Button(action:action)
		{
			ZStack
			{
				Text("?")
				Circle().fill(Color.primary.opacity(0.1))
				Circle().stroke(Color.primary, lineWidth:/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
			}
			.frame(width:size, height:size)
			.reducedOpacityWhenDisabled()
		}
		.buttonStyle(.borderless)
	}
	
	var size:CGFloat
	{
		switch controlSize
		{
			case .mini: return 10
			case .small: return 14
			case .regular: return 20
			case .large: return 24
			case .extraLarge:return 28
			@unknown default: return 20
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
