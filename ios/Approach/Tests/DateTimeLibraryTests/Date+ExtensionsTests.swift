import DateTimeLibrary
import XCTest

final class DateExtensionTests: XCTestCase {
	func testLongDateFormat() {
		let date = Date(timeIntervalSince1970: 0)
		XCTAssertEqual(date.longFormat, "January 1, 1970")
	}
}
