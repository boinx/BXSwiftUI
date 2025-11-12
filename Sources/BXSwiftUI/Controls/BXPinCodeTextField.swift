//**********************************************************************************************************************
//
//  BXPinCodeTextField.swift
//	Custom text field for entering pin codes
//  Copyright ©2025 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXPinCodeTextField : View
{
	/// Binding to the pincode property
	
	var pinCode:Binding<String>
	
	/// Number of digits
	
	var length:Int
	
	/// Size of each field
	
	var fieldSize:CGSize
	
	/// The spacing between fields
	
	var spacing:CGFloat
	
	/// The font used for drawing the digits
	
	var font:Font
	
	/// This closure is called when the Enter key is pressed
	
	var onCommit:(()->Void)? = nil
	
	/// True when this text field is focused, i.e. can receive ley events
	
	@State private var isFocused = false
	
	
//----------------------------------------------------------------------------------------------------------------------


	public init(pinCode:Binding<String>, length:Int, fieldSize:CGSize = CGSize(width:40,height:50), spacing:CGFloat = 10, font: SwiftUICore.Font = .system(size:32, weight:.bold, design:.default), onCommit: (() -> Void)? = nil)
	{
		self.pinCode = pinCode
		self.length = length
		self.fieldSize = fieldSize
		self.spacing = spacing
		self.font = font
		self.onCommit = onCommit
	}
	
	
	public var body: some View
    {
        ZStack
        {
            HStack(spacing:spacing)
            {
                ForEach(0..<length, id:\.self)
                {
					index in
					
                    ZStack
                    {
						// A: Draw background color for each field
						
                        RoundedRectangle(cornerRadius:6)
                            .fill(Color.primary.opacity(0.1))
					
						// B: Draw frame around it
						
                        RoundedRectangle(cornerRadius:6)
                            .stroke(borderColor(for:index), lineWidth:borderWidth(for:index))
                        
                        // C: Draw the digit on top
                        
                        Text(digit(at:index))
                            .font(font)
                    }
					.frame(width:fieldSize.width, height:fieldSize.height)
					
					// D: Because of A the field is opaque and click events are not routed to the parent view. We need to avoid this by disallowing hit testing at the field level
					
					.allowsHitTesting(false)
                }
            }
        }
        
        // Because of D we can receive key events at this level
        
		.onKeyDown(isFocused:{ self.isFocused = $0 })
		{
			let key = $0.key
			let char = $0.charactersIgnoringModifiers?.first ?? " "
			
			// Digit
			
			if char.isNumber
			{
				if pinCode.wrappedValue.count < length
				{
					pinCode.wrappedValue += String(char)
					self.update()
				}
			}
			
			// Backspace
			
			else if key == 127
			{
				let text = pinCode.wrappedValue
				let len = max(text.count-1,0)
				pinCode.wrappedValue = String(pinCode.wrappedValue.prefix(len))
				self.update()
			}
			
			// ESC clear all
			
			else if key == 27
			{
				pinCode.wrappedValue = ""
				self.update()
			}
			
			// Enter or return
			
			else if pinCode.wrappedValue.count == length, key == 3 || key == 13
			{
				onCommit?()
			}
			
			// Invalid key
			
			else
			{
				NSSound.beep()
			}
		}

		// Also accept strings via copy/paste
		
		.onPasteString
		{
			string in
			let digits = string.filter { $0.isNumber }
			pinCode.wrappedValue += digits
			self.update()
		}
    }

	/// Returns the digit at the specified index
	
    private func digit(at index:Int) -> String
    {
        guard index < pinCode.wrappedValue.count else { return "" }
        return String(Array(pinCode.wrappedValue)[index])
    }

	/// Returns the box border color at the specified index

    private func borderColor(for index:Int) -> Color
    {
		guard isFocused else { return .gray }
        return index == activeIndex ? .accentColor : .primary.opacity(0.5)
    }

	/// Returns the box border width at the specified index

    private func borderWidth(for index:Int) -> CGFloat
    {
		guard isFocused else { return 1 }
        return index == activeIndex ? 2 : 1
    }

	/// Returns the index of the currently active text box

	private var activeIndex:Int
	{
        min(pinCode.wrappedValue.count,5)
    }
    
    /// Call this function to force an update of this view
	
    private func update()
    {
		self._update += 1
    }
    
	@State private var _update = 0
}


//----------------------------------------------------------------------------------------------------------------------


fileprivate extension NSEvent
{
	/// Returns the key, useful for arrow keys or other function keys. This accessor return ASCII values, so space is 32 or ESC is 27
	///
	/// Please note that the returned values are DIFFERENT from the keyCode accessor, which return virtual codes, e.g. keyCode for spacebar doesn't return 32.
	
    var key:Int
	{
        guard let str = charactersIgnoringModifiers?.utf16  else { return 0 }
        let i = str.startIndex
        guard i < str.endIndex else { return 0 }
        return Int(str[i])
    }
}


//----------------------------------------------------------------------------------------------------------------------


#endif
