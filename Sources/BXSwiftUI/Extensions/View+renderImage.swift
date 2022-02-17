//**********************************************************************************************************************
//
//  View+renderImage.swift
//	Renders a SwiftUI View to a NSImage or UIImage
//  Copyright ©2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif


//----------------------------------------------------------------------------------------------------------------------


extension View
{
	/// Returns a rasterized Image of the original View
	
	@ViewBuilder public func asImage() -> some View
	{
		let image = self.renderImage(colorScheme:.light, isTemplate:false)
		
		if let image = image
		{
			SwiftUI.Image(nsImage:image)
		}
		else
		{
			EmptyView()
		}
	}

	#if os(macOS)

	/// Renders the view to an NSImage
	
	public func renderImage(colorScheme:ColorScheme = .dark, isTemplate:Bool = true) -> NSImage?
	{
		let view = NSHostingView(rootView:self.colorScheme(colorScheme))
        let size = view.intrinsicContentSize
        let bounds = CGRect(origin:.zero, size:size)
		view.frame = bounds
		
		guard let bitmap = view.bitmapImageRepForCachingDisplay(in:bounds) else { return nil }
		bitmap.size = size
		view.cacheDisplay(in:bounds, to:bitmap)

		let image = NSImage(size:size)
		image.addRepresentation(bitmap)
		image.isTemplate = isTemplate
		
		return image
	}

	#elseif os(iOS)

	/// Renders the view to a UIImage
	
	public func renderImage(colorScheme:ColorScheme = .dark, isTemplate:Bool = true) -> UIImage?
	{
        let controller = UIHostingController(rootView:self.colorScheme(colorScheme))
        guard let view = controller.view else { return nil }

        let size = view.intrinsicContentSize
        view.bounds = CGRect(origin:.zero, size:size)
        view.backgroundColor = UIColor.clear

        let image = UIGraphicsImageRenderer(size:size).image
        {
			_ in view.drawHierarchy(in:view.bounds, afterScreenUpdates:true)
        }
        
		image.isTemplate = isTemplate
		return image
	}

	#endif
}


//----------------------------------------------------------------------------------------------------------------------
