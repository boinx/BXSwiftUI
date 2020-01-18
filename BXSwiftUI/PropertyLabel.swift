import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct PropertyLabel : View
{
	var title:String = ""
	var width:CGFloat = 70.0
	
	init(_ title:String, width:CGFloat = 70.0)
	{
		self.title = title
		self.width = width
	}
	
	public var body: some View
	{
		return Text(title)
		
			// Measure the size of the Text and attach a preference (with its width) to the Text
			
			.background( GeometryReader
			{
				Color.clear.preference(
					key:PropertyLabelKey.self,
					value:[PropertyLabelData(width:$0.size.width)])

			})
			
			// Resize the text to the desired width - which will be the maximum width of all PropertyLabels
			
			.frame(minWidth:width, alignment:.leading)
//			.border(Color.red)
	}
}


//----------------------------------------------------------------------------------------------------------------------


/// Metadata to be attached to PropertyLabel views

struct PropertyLabelData : Equatable
{
    let width:CGFloat
}


struct PropertyLabelKey : PreferenceKey
{
    typealias Value = [PropertyLabelData]

	static var defaultValue:[PropertyLabelData] = []

    static func reduce(value:inout [PropertyLabelData], nextValue:()->[PropertyLabelData])
    {
		value.append(contentsOf: nextValue())
    }
}


//----------------------------------------------------------------------------------------------------------------------
