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
			// Title
			
			Text(title)
				.lineLimit(1)
			
			// Progress Bar
			
			HStack
			{
				BXProgressBar(isIndeterminate:controller.isIndeterminate, value:controller.fraction, minValue:0, maxValue:1)
				
					.id(controller.isIndeterminate) // WORKAROUND: Since switching isIndeterminate on/off doesn't work for some reason, we'll simply use id to completely replace the NSProgressIndicator instance with a new one when the value of isIndeterminate changes. Now we get to see the animation!
					
				if BXProgressViewController.cancelHandler != nil
				{
					Button(action:cancel)
					{
						BXImage(systemName:"xmark.circle")
					}
					.buttonStyle(.borderless)
				}
			}
			
			// Detail Message
			
			Text(message)
				.font(.caption)
				.lineLimit(1)
				.opacity(0.5)
		}
		.padding()
		.edgesIgnoringSafeArea(.all) // This is essential to make the view extend below transparent titlebar of an NSWindow!
	}
	
	func cancel()
	{
		#if os(macOS)
		BXProgressWindowController.isCancelled = true
		#endif
		BXProgressViewController.cancelHandler?()
	}
}

	
//----------------------------------------------------------------------------------------------------------------------
