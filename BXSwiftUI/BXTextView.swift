//**********************************************************************************************************************
//
//  BXTextView.swift
//	SwiftUI wrapper for NSTextView
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


/// BXTextView wraps an NSTextView on macOS or a UITextView on iOS. It doesn't need to be enclosed in a
/// ScrollView, since it can resize itself automatically to fit the dimensions of its text.

public struct BXTextView : View
{
    private var value:Binding<NSAttributedString>
	private var isActiveHandler:(BXTextViewActiveHandler)? = nil

	@State private var fittingSize:CGSize = CGSize(width:20, height:20)


	/// BXTextView wraps an NSTextView on macOS or a UITextView on iOS. It doesn't need to be enclosed in a
	/// ScrollView, since it can resize itself automatically to fit the dimensions of its text.
	///
	/// - parameter value: The NSAttributedString containing the text to be edited
	/// - parameter isActiveHandler: A closure that is called repeatedly as the mouse enters or exits the view,
	/// or when editing starts or ends. Can be used to change the appearance of the view.

	public init(value:Binding<NSAttributedString>, isActiveHandler:(BXTextViewActiveHandler)? = nil)
	{
		self.value = value
		self.isActiveHandler = isActiveHandler
	}
	

	public var body: some View
	{
		#if os(macOS)
		
		return BXTextView_macOS(value:self.value, fittingSize:self.$fittingSize, isActiveHandler:isActiveHandler)
			
			// Since we are dealing with rich text, we do not really know where the first baseline should be.
			// So simply assume the first text baseline to be 15pt from the top.
			
			.alignmentGuide(.firstTextBaseline) { _ in return 15.0 }
			
			// Once the correct fitting size has been calculated and set, resize the view to the exact height.
			
			.frame(height:self.fittingSize.height)
			
		#elseif os(iOS)
		
		#warning("TODO: implement")
		
		#endif
	}
}


//----------------------------------------------------------------------------------------------------------------------


