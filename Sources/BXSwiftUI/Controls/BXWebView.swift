//**********************************************************************************************************************
//
//  BXWebView.swift
//	Wraps a WKWebView
//  Copyright ©2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import WebKit


//----------------------------------------------------------------------------------------------------------------------


public struct BXWebView : NSViewRepresentable
{
	// Params
	
	var url:URL
	
	// Init
	
	public init(url:URL)
	{
		self.url = url
	}
	
	// Create the underlying AppKit view
	
	public func makeNSView(context:Context) -> WKWebView
    {
    	let webView = WKWebView(frame:.zero)
 		return webView
    }

	// Load the webpage at the specified URL
	
	public func updateNSView(_ webView:WKWebView, context:Context)
    {
		webView.load(URLRequest(url:self.url))
	}

	// Unload the webpage (this stops audio and video playback)
	
	public static func dismantleNSView(_ webView:WKWebView, coordinator:Self.Coordinator)
    {
		let stop = URL(string:"about:blank")!
		let request = URLRequest(url:stop)
		webView.load(request)
    }
}


//----------------------------------------------------------------------------------------------------------------------

#endif
