//**********************************************************************************************************************
//
//  BXSliderStyle.swift
//	A circular slider for SwiftUI
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public protocol BXSliderStyle
{
    associatedtype Body : View
    
    typealias Configuration = BXSliderStyleConfiguration

    func makeBody(configuration: Self.Configuration) -> Self.Body
}


public struct BXSliderStyleConfiguration
{
	public var values:Binding<Set<Double>>
	private var range:ClosedRange<Double> = 0.0 ... 1.0
	public var response:BXSliderResponse = .linear
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXSliderStyleKey : EnvironmentKey
{
    static public let defaultValue = BXDefaultSliderStyle()
}

public extension EnvironmentValues
{
    var bxSliderStyle : some BXSliderStyle
    {
        set
        {
            self[BXSliderStyleKey.self] = newValue
        }

        get
        {
            return self[BXSliderStyleKey.self]
        }
    }
}

public extension View
{
	func bxSliderStyle<S:BXSliderStyle>(_ style:S) -> some View
    {
        self.environment(\.bxSliderStyle, style)
    }
}


//----------------------------------------------------------------------------------------------------------------------


public struct BXDefaultSliderStyle : BXSliderStyle
{
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.bxColorTheme) private var bxColorTheme
	@Environment(\.bxUndoManager) private var undoManager
	@Environment(\.bxUndoName) private var undoName
}


//----------------------------------------------------------------------------------------------------------------------
