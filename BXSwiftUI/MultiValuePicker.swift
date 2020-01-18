import FotoMagicoCore
import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


struct MultiValuePicker : NSViewRepresentable
{
	@Binding var values:Set<Int>
	var allCases:[LocalizableIntEnum] = []

    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
    
    func makeNSView(context:Context) -> NSPopUpButton
    {
        let popup = NSPopUpButton(frame:.zero)
        popup.autoenablesItems = false
        
        let item2 = NSMenuItem(title:"none", action:nil, keyEquivalent:"")
		item2.tag = -2
		item2.isEnabled = false
		item2.isHidden = true
		popup.menu?.addItem(item2)
        
		let item1 = NSMenuItem(title:"multiple", action:nil, keyEquivalent:"")
		item1.tag = -1
		item1.isEnabled = false
		item1.isHidden = true
		popup.menu?.addItem(item1)
        
        for info in self.allCases
        {
			let item = NSMenuItem(title:info.localizedName, action:nil, keyEquivalent:"")
			item.tag = info.intValue
			item.isEnabled = true
			popup.menu?.addItem(item)
        }
        
		popup.target = context.coordinator
		popup.action = #selector(Coordinator.updateValues(with:))
		return popup
    }

    func updateNSView(_ popup:NSPopUpButton, context:Context)
    {
		popup.menu?.item(withTag:-2)?.isHidden = values.count > 0
		popup.menu?.item(withTag:-1)?.isHidden = values.count == 0
		popup.isEnabled = values.count > 0

		if values.count > 1
		{
			popup.selectItem(withTag:-1)
		}
		else if let value = values.first
		{
			popup.selectItem(withTag:value)
		}
		else
		{
			popup.selectItem(withTag:-2)
		}
    }
    
    class Coordinator : NSObject
    {
        var picker:MultiValuePicker

        init(_ picker:MultiValuePicker)
        {
            self.picker = picker
        }

        @objc func updateValues(with sender:NSPopUpButton)
        {
			let tag = sender.selectedTag()
			picker.values = Set([tag])
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------
