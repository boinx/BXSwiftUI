//**********************************************************************************************************************
//
//  BXProgressWindowController.swift
//	A progress bar window that can be presented modally or as a sheet
//  Copyright ©2020-2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import BXSwiftUtils
import AppKit


//----------------------------------------------------------------------------------------------------------------------


open class BXProgressWindowController : NSWindowController
{
	/// Shared singleton instance of the BXProgressWindowController
	
	public static let shared = BXProgressWindowController(window:nil)

	/// The window for this controller is loaded lazily when accessing this property
	
	override open var window:NSWindow?
	{
		set
		{
			super.window = newValue
		}
		
		get
		{
			if super.window == nil { self.loadWindow() }
			return super.window
		}
	}
	
	/// The current model session

	private var modalSession:NSApplication.ModalSession? = nil
	
	/// Returns the observable BXProgressViewController
	
	var viewController:BXProgressViewController?
	{
		self.contentViewController as? BXProgressViewController
	}
	
	/// Loads the window and its view hierarchy
	
	override open func loadWindow()
	{
		let frame = CGRect(x:0, y:0, width:360, height:88)
		let style:NSWindow.StyleMask = [.nonactivatingPanel,.titled,.fullSizeContentView]			// .titled is necessary here to get a window with rounded corners - even though we do not want a titlebar!
		let window = NSPanel(contentRect:frame, styleMask:style, backing:.buffered, defer:true)		// .nonactivatingPanel is necessary for full window draggabilty
		
		window.titleVisibility = .hidden															// These two lines hide
		window.titlebarAppearsTransparent = true													// the titlebar again
		window.hasShadow = true
		window.isMovable = true
		window.isMovableByWindowBackground = true
		window.contentViewController = BXProgressViewController(nibName:nil, bundle:nil)

		self.window = window
	}
	

//----------------------------------------------------------------------------------------------------------------------


	// MARK: -
	
	open var title:String = ""
	{
		didSet
		{
			DispatchQueue.main.asyncIfNeeded
			{
				self.viewController?.progressTitle = self.title
			}
		}
	}
	
	open var message:String = ""
	{
		didSet
		{
			DispatchQueue.main.asyncIfNeeded
			{
				self.viewController?.progressMessage = self.message
			}
		}
	}
	
	open var value:Double = 0.0
	{
		didSet
		{
			DispatchQueue.main.asyncIfNeeded
			{
				self.viewController?.fraction = self.value
			}
		}
	}
	
	open var isIndeterminate = false
	{
		didSet
		{
			DispatchQueue.main.asyncIfNeeded
			{
				self.viewController?.isIndeterminate = self.isIndeterminate
			}
		}
	}
	
	open var cancelHandler:(()->Void)?
	{
		didSet
		{
			BXProgressViewController.cancelHandler = self.cancelHandler
		}
	}

	open var isVisible:Bool
	{
		self.window?.isVisible ?? false
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	// MARK: -
	
	open func show()
	{
		DispatchQueue.main.async
		{
			guard let window = self.window else { return }
			
			window.center()
			window.makeKeyAndOrderFront(nil)

			let session = NSApp.beginModalSession(for:window)
			NSApp.runModalSession(session)
			self.modalSession = session
		}
	}
	
	
	open func hide()
	{
		DispatchQueue.main.asyncIfNeeded
		{
			self.close()
		}
	}

	override open func close()
	{
		if let session = self.modalSession
		{
			NSApp.endModalSession(session)
		}
		
		super.close()
		self.unloadWindow()
	}
	
	func unloadWindow()
	{
		self.contentViewController = nil
		self.window = nil
		self.modalSession = nil
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
