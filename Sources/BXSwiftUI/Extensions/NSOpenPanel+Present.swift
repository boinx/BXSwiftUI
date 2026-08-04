//**********************************************************************************************************************
//
//  NSOpenPanel+Present.swift
//	Convenience function to show an NSOpenPanel
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit
import UniformTypeIdentifiers


//----------------------------------------------------------------------------------------------------------------------


internal extension UTType
{
	/// Creates a UTType from a string that is either a UTI identifier ("public.image") or a bare filename
	/// extension ("gpx"). The deprecated NSOpenPanel.allowedFileTypes accepted both forms, so this keeps the
	/// presentModal(…) API source compatible while moving to allowedContentTypes underneath.
	///
	/// The two lookups are disjoint - an identifier never resolves as an extension and vice versa - so the
	/// order does not matter. Unknown extensions yield a dynamic ("dyn.…") type, which still filters correctly,
	/// so nothing is silently dropped.

	init?(fileType:String)
	{
		if let type = UTType(fileType)
		{
			self = type
		}
		else if let type = UTType(filenameExtension:fileType)
		{
			self = type
		}
		else
		{
			return nil
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


public extension NSOpenPanel
{
	class func presentModal(title:String? = nil, message:String? = nil, buttonLabel:String? = nil, directoryURL:URL? = nil, allowedFileTypes:[String]? = nil, canChooseFiles:Bool = true, canChooseDirectories:Bool = false, allowsMultipleSelection:Bool = false, appearance:NSAppearance? = nil, handler:([URL])->Void)
	{
		let panel = NSOpenPanel()
		
		panel.appearance = appearance
		panel.canCreateDirectories = true
		panel.canChooseFiles = canChooseFiles
		panel.canChooseDirectories = canChooseDirectories
		panel.allowsMultipleSelection = allowsMultipleSelection

		if let title = title
		{
			panel.title = title
		}
		
		if let message = message
		{
			panel.message = message
		}
		
		if let buttonLabel = buttonLabel
		{
			panel.prompt = buttonLabel
		}

		if let allowedFileTypes = allowedFileTypes
		{
			panel.allowedContentTypes = allowedFileTypes.compactMap { UTType(fileType:$0) }
		}

		if let directoryURL = directoryURL
		{
			panel.directoryURL = directoryURL
		}

		let button = panel.runModal()
		
		if button == NSApplication.ModalResponse.OK
		{
			handler(panel.urls)
		}
		else
		{
			handler([])
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
