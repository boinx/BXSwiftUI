//**********************************************************************************************************************
//
//  BXMessageBox.swift
//	Displays a text message in a box with an icon - much like an "inline alert"
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI
				
			
//----------------------------------------------------------------------------------------------------------------------


public struct BXMessageBox<Content:View> : View
{
	// Params
	
	private var style:Style
	private var size:CGFloat
	private var alignment:VerticalAlignment
	private var content:()->Content

	// Style
	
	@Environment(\.colorScheme) private var colorScheme

	public enum Style
	{
		case none
		case info
		case warning
		case error
	}
	
	// Init
	
	public init(style:Style = .warning, size:CGFloat = 28, alignment:VerticalAlignment = .center, @ViewBuilder content:@escaping ()->Content)
	{
		self.style = style
		self.size = size
		self.alignment = alignment
		self.content = content
	}
	
	// Build View
	
	public var body: some View
    {
		HStack(alignment:alignment)
		{
			if style != .none
			{
				Text(style.icon).font(.system(size:size))
			}
			
			self.content()
			Spacer()
		}
		.padding(8)
		.background(style.fillColor(for:colorScheme))
		.border(style.strokeColor)
	}
}


//----------------------------------------------------------------------------------------------------------------------


extension BXMessageBox.Style
{
	var icon:String
	{
		switch self
		{
			case .none: return ""
			case .info: return "💬"
			case .warning: return "⚠️"
			case .error: return "🛑"
		}
	}
	
	func fillColor(for colorScheme:ColorScheme) -> Color
	{
		let alpha = colorScheme == .dark ? 0.1 : 0.4
		
		switch self
		{
			case .none: return Color.white.opacity(alpha)
			case .info: return Color.white.opacity(alpha)
			case .warning: return Color.yellow.opacity(0.2)
			case .error: return Color.red.opacity(0.2)
		}
	}

	var strokeColor:Color
	{
		Color.primary.opacity(0.25)
	}
}


//----------------------------------------------------------------------------------------------------------------------
