//**********************************************************************************************************************
//
//  BXWebView.swift
//	Wraps a WKWebView
//  Copyright ©2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


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

	// SwiftUI side has changed, so update the AppKit view
	
	public func updateNSView(_ webView:WKWebView, context:Context)
    {
		let request = URLRequest(url:self.url)
		webView.load(request)
	}
}


//----------------------------------------------------------------------------------------------------------------------
