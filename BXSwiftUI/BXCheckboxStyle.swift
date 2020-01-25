//**********************************************************************************************************************
//
//  BXCircularSlider.swift
//	A circular slider for SwiftUI
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXCheckboxStyle : ToggleStyle
{
	public init()
	{
	
	}
	
	public func makeBody(configuration:Self.Configuration) -> some View
    {
        configuration.label
            .border(Color.green)
//            .padding()
//            .foregroundColor(.white)
//            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
//            .cornerRadius(40)
//            .padding(.horizontal, 20)
    }
}


//----------------------------------------------------------------------------------------------------------------------

/*
public struct ToggleStyleConfiguration {

    /// A type-erased label of a `Toggle`.
    public struct Label : View {

        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required `body` property.
        public typealias Body = Never
    }

    /// A view that describes the effect of toggling `isOn`.
    public let label: ToggleStyleConfiguration.Label

    /// Whether or not the toggle is currently "on" or "off".
    public var isOn: Bool { get nonmutating set }

    public var $isOn: Binding<Bool> { get }
}
*/
