//**********************************************************************************************************************
//
//  BXProgressView.swift
//	A view with a progress bar and textual information
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXProgressView : View
{
	@ObservedObject var controller:BXProgressViewController
	
	public init(controller:BXProgressViewController)
	{
		self.controller = controller
	}
	
	public var body: some View
	{
		let title  = controller.progressTitle ?? " "
		let message = controller.progressMessage ?? " "
		
		VStack(alignment:.leading, spacing:4)
		{
			Text(title)
				.lineLimit(1)
				
			HStack
			{
				BXProgressBar(isIndeterminate:controller.isIndeterminate, value:controller.fraction, minValue:0, maxValue:1)
				
				if let cancelHandler = BXProgressViewController.cancelHandler
				{
					Button(action:cancelHandler)
					{
						BXImage(systemName:"xmark.circle")
					}
					.buttonStyle(.borderless)
				}
			}
			
			Text(message)
				.font(.caption)
				.lineLimit(1)
				.opacity(0.5)
		}
		.padding()
		.edgesIgnoringSafeArea(.all) // This is essential to make the view extend below transparent titlebar of an NSWindow!
	}
}

	
//----------------------------------------------------------------------------------------------------------------------
