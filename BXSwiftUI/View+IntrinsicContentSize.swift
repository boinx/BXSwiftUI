//**********************************************************************************************************************
//
//  View+IntrinsicContentSize.swift
//	Adds convenience function for intrinsicContentSize to View
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


extension View
{
	/// Sets the intrinsic content size of a view. This helps the SwiftUI layout system to do the right thing.
	
	public func intrinsicContentSize(width:CGFloat? = nil, height:CGFloat? = nil) -> some View
	{
		return self
			.frame(idealWidth:width, idealHeight:height)
			.fixedSize(horizontal:width != nil, vertical:height != nil)
	}
}


//----------------------------------------------------------------------------------------------------------------------
