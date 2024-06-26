//**********************************************************************************************************************
//
//  BXProgressViewController.swift
//	A progress bar window that can be presented modally or as a sheet
//  Copyright ©2020-2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


#if os(macOS)

import AppKit

open class BXProgressViewController : NSViewController, ObservableObject
{
	@Published open var progressTitle:String? = nil
	@Published open var isIndeterminate:Bool = false
	@Published open var fraction:Double = 0.0
	@Published open var progressMessage:String? = nil
	public static var cancelHandler:(()->Void)? = nil

	override open func loadView()
	{
		let frame = CGRect(x:0, y:0, width:360, height:88)
		self.view = BXProgressBackgroundView(frame:frame)
		
		// Create a SwiftUI view that observes the properties of this controller.
		//
		// ATTENTION: This creates a retain cycle self -> view -> NSHostingView -> BXProgressView -> self
		
		let hostView = NSHostingView(rootView: BXProgressView(controller:self))
		hostView.frame = frame
		self.view.addSubview(hostView)
		hostView.translatesAutoresizingMaskIntoConstraints = false
		hostView.topAnchor.constraint(equalTo:view.topAnchor, constant:0).isActive = true
		hostView.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:0).isActive = true
		hostView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant:0).isActive = true
		hostView.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant:0).isActive = true
	}
		
	override open func viewDidDisappear()
	{
		super.viewDidDisappear()

		// Break the retain cycle from above
		
		self.view = NSView(frame:.zero)
	}
}


public class BXProgressBackgroundView : NSView
{
	override public var mouseDownCanMoveWindow: Bool
	{
		true
	}
}


#endif

	
//----------------------------------------------------------------------------------------------------------------------


#if os(iOS)

import UIKit

open class BXProgressViewController : UIHostingController<BXProgressView>, ObservableObject
{
	@Published open var progressTitle:String? = nil
	@Published open var isIndeterminate:Bool = false
	@Published open var fraction:Double = 0.0
	@Published open var progressMessage:String? = nil
	public static var cancelHandler:(()->Void)? = nil

	override open func loadView()
	{
		// ATTENTION: This creates a retain cycle self -> rootView -> BXProgressView -> self

		self.rootView = BXProgressView(controller:self)
	}
	
	override open func viewDidDisappear(_ animated:Bool)
	{
		super.viewDidDisappear(animated)
		
		// Break the retain cycle from above
		
		self.view = UIView(frame:.zero)
	}
}


#endif

	
//----------------------------------------------------------------------------------------------------------------------
