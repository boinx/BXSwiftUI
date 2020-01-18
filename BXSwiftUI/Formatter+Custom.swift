import Foundation


//----------------------------------------------------------------------------------------------------------------------


public extension Formatter
{
	static var secondsFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 2
		formatter.positiveFormat = "#.##s"
		formatter.negativeFormat = "-#.##s"
		return formatter
	}()

	static var degreesFormatter: NumberFormatter =
	{
		let formatter = NumberFormatter()
		formatter.allowsFloats = true
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 1
		formatter.positiveFormat = "#.#°"
		formatter.negativeFormat = "-#.#°"
		return formatter
	}()
}


//----------------------------------------------------------------------------------------------------------------------

