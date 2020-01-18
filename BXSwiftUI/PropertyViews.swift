import FotoMagicoCore
import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct StringPropertyView : View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>
	public var value:Binding<String?>
//	@Binding public var labelWidth:CGFloat
//	@Binding public var value:String?

	public init(label:String = "", labelWidth:Binding<CGFloat>, value:Binding<String?>)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
	}
	
    public var body: some View
    {
		HStack
		{
			PropertyLabel(label, width:labelWidth.wrappedValue)
				
			CustomTextField(value:value, height:22.0, alignment:.leading)
			{
				(nstextfield,_,_) in
				nstextfield.isBordered = true
				nstextfield.drawsBackground = true
			}
		}
	}
}


public struct MultiStringPropertyView : View
{
	public var label:String = ""
	@Binding public var labelWidth:CGFloat
	@Binding public var values:Set<String>
	
    public var body: some View
    {
		HStack
		{
			PropertyLabel(label, width:labelWidth)
				
			MultiValueTextField(values:$values, height:22.0, alignment:.leading)
			{
				nstextfield,_,_ in
				nstextfield.isBordered = true
				nstextfield.drawsBackground = true
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct BoolPropertyView : View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>
	public var value:Binding<Bool>
//	@Binding public var labelWidth:CGFloat
//	@Binding public var value:Bool

	public init(label:String = "", labelWidth:Binding<CGFloat>, value:Binding<Bool>)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
	}
	
	public var body: some View
	{
		HStack
		{
			PropertyLabel(label, width:labelWidth.wrappedValue)
			Toggle("Enabled", isOn:value)
			Spacer()
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


public struct MultiBoolPropertyView : View
{
	public var label:String = ""
	@Binding public var labelWidth:CGFloat
	@Binding public var values:Set<Bool>

	public var body: some View
	{
		HStack
		{
			PropertyLabel(label, width:labelWidth)
			MultiValueToggle(values:$values, label:"Enabled")
			Spacer()
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct DoublePropertyView: View
{
	public var label:String = ""
	public var labelWidth:Binding<CGFloat>
	public var value:Binding<Double>
//	@Binding public var labelWidth:CGFloat
//	@Binding public var value:Double
	public var range:ClosedRange<Double> = 0.0...60.0
	public var formatter:Formatter? = nil
	
	public init(label:String = "", labelWidth:Binding<CGFloat>, value:Binding<Double>, range:ClosedRange<Double> = 0.0...60.0, formatter:Formatter? = nil)
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
		self.range = range
		self.formatter = formatter
	}
	
    public var body: some View
    {
		return VStack(alignment:.leading, spacing:-10.0)
		{
			HStack
			{
				Text(label)

				Spacer()

				CustomTextField(value:value, height:17, alignment:.trailing, formatter:formatter)
				{
					(nstextfield,isFirstResponder,isHovering) in
					let isActive = isFirstResponder || isHovering
					nstextfield.isBordered = false
					nstextfield.drawsBackground = isActive
					nstextfield.layer?.borderWidth = isActive ? 1.0 : 0.0
					nstextfield.layer?.borderColor = NSColor.lightGray.cgColor
				}
				.frame(width:60.0)
				.offset(x:0,y:1)
			}
			
			Slider(value:value, in:range)
				.zIndex(-1)
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


public struct MultiDoublePropertyView: View
{
	public var label:String = ""
	@Binding public var labelWidth:CGFloat
	@Binding public var values:Set<Double>
	public var range:ClosedRange<Double> = 0.0...60.0
	public var formatter:Formatter? = nil
	
	private var value:Double
	{
		return values.first ?? 0.0
	}
	
    public var body: some View
    {
		return VStack(alignment:.leading, spacing:-2.0)
		{
			HStack
			{
				Text(label)

				Spacer()

				MultiValueTextField(values:$values, height:17, alignment:.trailing, formatter:formatter)
				{
					(nstextfield,isFirstResponder,isHovering) in
					let isActive = isFirstResponder || isHovering
					nstextfield.isBordered = false
					nstextfield.drawsBackground = isActive
					nstextfield.layer?.borderWidth = isActive ? 1.0 : 0.0
					nstextfield.layer?.borderColor = NSColor.lightGray.cgColor
				}
				.frame(width:60.0)
				.offset(x:0,y:1)
			}
			
			MultiValueSlider(values:$values, in:range)
				.zIndex(-1)
		}
		.frame(maxHeight:24.0, alignment:.top)
	}
}


//----------------------------------------------------------------------------------------------------------------------


public struct IntPropertyView : View
{
	public var label:String = ""
//	@Binding public var labelWidth:CGFloat
//	@Binding public var value:Int
	public var labelWidth:Binding<CGFloat>
	public var value:Binding<Int>
	public var allCases:[LocalizableIntEnum] = []
	
	public init(label:String = "", labelWidth:Binding<CGFloat>, value:Binding<Int>, allCases:[LocalizableIntEnum])
	{
		self.label = label
		self.labelWidth = labelWidth
		self.value = value
		self.allCases = allCases
	}
	
    public var body: some View
    {
		HStack
		{
			PropertyLabel(label, width:labelWidth.wrappedValue)

			Picker(selection:value, label:Text(""))
			{
				ForEach(allCases, id:\.intValue)
				{
					Text($0.localizedName).tag($0.intValue)
				}
			}
			.labelsHidden()
		}
	}
}


public struct MultiIntPropertyView : View
{
	public var label:String = ""
	@Binding public var labelWidth:CGFloat
	@Binding public var values:Set<Int>
	public var allCases:[LocalizableIntEnum] = []
	
	var isUnique:Bool { values.count < 2 }
	
    public var body: some View
    {
		HStack
		{
			PropertyLabel(label, width:labelWidth)
			MultiValuePicker(values:$values, allCases:allCases)
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


