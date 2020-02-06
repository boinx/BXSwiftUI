//**********************************************************************************************************************
//
//  View+Tooltip.swift
//	An extension that attaches macOS tooltips to views
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public extension View
{
	/// Attaches a tooltip to a view hierarchy
	
    func setToolTip(_ toolTip:String?) -> some View
    {
		Group
		{
			if BXToolTipView.isEnabled
			{
				self.background(BXToolTipView(toolTip)) // Put BXToolTipView in behind, so that mouse events are not "stolen" from the view hierarchy!
			}
		}
    }
    
    static func setToolTipsEnabled(_ isEnabled:Bool)
    {
		BXToolTipView.isEnabled = isEnabled
    }
}
  
  
//----------------------------------------------------------------------------------------------------------------------


public struct BXToolTipView : NSViewRepresentable
{
	internal static var isEnabled = true
    private let toolTip:String?
  
    init(_ toolTip:String?)
    {
        self.toolTip = toolTip
    }
  
	public func makeNSView(context:Context) -> NSView
	{
        let view = NSView()
        view.toolTip = self.toolTip
        return view
    }
  
	public func updateNSView(_ nsView:NSView, context:Context)
    {
    
    }
}


//----------------------------------------------------------------------------------------------------------------------
