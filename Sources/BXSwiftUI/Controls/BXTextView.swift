//**********************************************************************************************************************
//
//  BXTextView.swift
//	SwiftUI wrapper for NSTextView
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


/// BXTextView wraps an NSTextView on macOS or a UITextView on iOS. It doesn't need to be enclosed in a
/// ScrollView, since it can resize itself automatically to fit the dimensions of its text.

public struct BXTextView : View
{
	// Params
	
    private var value:Binding<NSAttributedString>
	private var statusHandler:(BXTextViewStatusHandler)? = nil
	private var onBegan:(()->Void)? = nil
	private var onEnded:(()->Void)? = nil

	// Environment
	
	@Environment(\.controlSize) private var controlSize

	// Private State
	
	@State private var fittingSize:CGSize = CGSize(width:20, height:20)

	/// BXTextView wraps an NSTextView on macOS or a UITextView on iOS. It doesn't need to be enclosed in a
	/// ScrollView, since it can resize itself automatically to fit the dimensions of its text.
	///
	/// - parameter value: The NSAttributedString containing the text to be edited
	/// - parameter isActiveHandler: A closure that is called repeatedly as the mouse enters or exits the view,
	/// or when editing starts or ends. Can be used to change the appearance of the view.

	public init(value:Binding<NSAttributedString>, statusHandler:(BXTextViewStatusHandler)? = nil, onBegan:(()->Void)? = nil, onEnded:(()->Void)? = nil)
	{
		self.value = value
		self.statusHandler = statusHandler
		self.onBegan = onBegan
		self.onEnded = onEnded
	}
	
	
	// Build the view
	
	public var body: some View
	{
		#if os(macOS)
		
		return BXTextView_macOS(value:self.value, fittingSize:self.$fittingSize, statusHandler:statusHandler, onBegan:onBegan, onEnded:onEnded)
			
			// Since we are dealing with rich text, we do not really know where the first baseline should be.
			// So simply use a hardcoded value that looks good relative to the view frame.
			
			.alignmentGuide(.firstTextBaseline) { _ in return self.firstBaselineOffset }
			
			// Once the correct fitting size has been calculated, resize the view to the exact height
			
			.intrinsicContentSize(height:self.fittingSize.height)
			
		#elseif os(iOS)
		
		#warning("TODO: implement")
		
		#endif
	}
	
	private var firstBaselineOffset : CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 15.0
			case .small: 		if #available(macOS 14,*) { return 14.0 } else { return 11.0 } // Fix macOS Sonoma layout problems
			case .mini: 		return 8.0
			default:			return 15.0
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
