//**********************************************************************************************************************
//
//  FMMacPlaybackAssistantView.swift
//	Displays the Playback Assistant
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// BXScreenPicker lets you select an NSScreen from all available NSScreens.
/// - parameter value: The binding to the selected NSScreen (can be nil)
/// - parameter deselectedView: The view to be drawn for an unselected NSScreen
/// - parameter selectedView: The view to be drawn for the selected NSScreen

public struct BXScreenPicker<DeselectedView:View,SelectedView:View> : View
{
	// Params
	
	private var value:Binding<NSScreen?>
	private var deselectedView:(NSScreen)->DeselectedView
	private var selectedView:(NSScreen)->SelectedView
	
	// Internal
	
	private var displays:[Display] = []
	private var enclosingRect = CGRect.zero
	
	struct Display : Identifiable
	{
		var id:Int
		var screen:NSScreen
		var frame:CGRect
	}
	
	/// BXScreenPicker lets you select an NSScreen from all available NSScreens.
	/// - parameter value: The binding to the selected NSScreen (can be nil)
	/// - parameter deselectedView: The view to be drawn for an unselected NSScreen
	/// - parameter selectedView: The view to be drawn for the selected NSScreen
	
	public init(value:Binding<NSScreen?>, @ViewBuilder deselectedView:@escaping (NSScreen)->DeselectedView, @ViewBuilder selectedView:@escaping (NSScreen)->SelectedView)
	{
		// Store params
		
		self.value = value
		self.deselectedView = deselectedView
		self.selectedView = selectedView
		
		// Get list of NSScreens and calculate the enclosingRect
		
		for (id,screen) in NSScreen.screens.enumerated()
		{
			let frame = screen.frame
			self.displays += Display(id:id, screen:screen, frame:frame)
			self.enclosingRect = NSUnionRect(enclosingRect,frame)
		}
	}

	// Build View
	
	public var body: some View
    {
		GeometryReader
		{
			geometry in
			
			// Create a BXScreenView for each NSScreen
			
			ForEach(self.displays, id:\.id)
			{
				display in
				
				BXScreenView(
					screen: display.screen,
					isSelected: self.isSelected(for:display),
					deselectedView: self.deselectedView,
					selectedView: self.selectedView)
				
					// Resize and move it to the correct place
					
					.frame(
						width:self.width(for:display,geometry:geometry),
						height:self.height(for:display,geometry:geometry))
						
					.offset(self.offset(for:display,geometry:geometry))
					
					// When clicked then select the corresponding NSScreen
					
					.onTapGesture
					{
						self.value.wrappedValue = display.screen
					}
			}
		}
    }
 }
 

//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// Draws the visual representation for a single NSScreen. Depending on the value of isSelected one of the two views will be used.
/// - parameter isSelected: Determines which of the following views gets drawn
/// - parameter deselectedView: This view gets drawn if isSelected is false
/// - parameter selectedView: This view gets drawn if isSelected is true

struct BXScreenView<DeselectedView:View,SelectedView:View> : View
{
	// Params
	
	var screen:NSScreen
	var isSelected = false
	var deselectedView:(NSScreen)->DeselectedView
	var selectedView:(NSScreen)->SelectedView

	// Build View
	
    var body: some View
    {
		Group
		{
			if self.isSelected
			{
				self.selectedView(self.screen)
			}
			else
			{
				self.deselectedView(self.screen)
			}
		}
		.clipped()
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

extension BXScreenPicker
{
    /// Returns true if the specified display is currently selected
    
	func isSelected(for display:Display) -> Bool
	{
		display.screen===self.value.wrappedValue
	}
	
	/// Returns the width (in screen points) for the BXScreenView for the specified display
	
	func width(for display:Display, geometry:GeometryProxy) -> CGFloat
	{
		let f = scale(for:geometry)
		return f * display.frame.width
	}
	
	/// Returns the height (in screen points) for the BXScreenView for the specified display
	
	func height(for display:Display, geometry:GeometryProxy) -> CGFloat
	{
		let f = scale(for:geometry)
		return f * display.frame.height
	}
	
	/// Returns the offset (in screen points) for the BXScreenView for the specified display
	
	func offset(for display:Display, geometry:GeometryProxy) -> CGSize
	{
		let f = scale(for:geometry)

		let W = enclosingRect.width
		let H = enclosingRect.height
		let w = geometry.size.width
		let h = geometry.size.height
		
		let dx1 = f * (display.frame.minX - enclosingRect.minX)
		let dy1 = f * (enclosingRect.maxY - display.frame.maxY)
		let dx2 = 0.5 * (w - f*W)
		let dy2 = 0.5 * (h - f*H)

		return CGSize(dx1+dx2,dy1+dy2)
	}
	
	/// Returns the scale factor for the BXScreenViews to fit them all into this BXScreenPicker
	
	func scale(for geometry:GeometryProxy) -> CGFloat
    {
		let W = max(1, enclosingRect.width)
		let H = max(1, enclosingRect.height)
		let w = geometry.size.width
		let h = geometry.size.height
		let fx = w / W
		let fy = h / H
		return min(fx,fy)
   }

	/// Default view for non-selected screens

	public static func defaultDeselectedView(for screen:NSScreen) -> some View
	{
		Color.primary.opacity(0.1)
			.border(Color.primary.opacity(0.5), width:1)
	}

	/// Default view for the selected screen
	
	public static func defaultSelectedView(for screen:NSScreen) -> some View
	{
		Color.primary.opacity(0.1)
			.border(Color.primary.opacity(1.0), width:4)
	}
}


//----------------------------------------------------------------------------------------------------------------------
