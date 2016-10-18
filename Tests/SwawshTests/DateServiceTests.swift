import XCTest
import Foundation

@testable import Swawsh

class FakeDateFormatter: DateFormatterProtocol {
    
    var timeZone: TimeZone!
    var dateFormat: String!
    
    func string(from: Date) -> String {
        return "Yesterday you said tomorrow. JUST DO IT!"
    }
}

class DateServiceTests: XCTestCase {
    
    var subject: DateService?
    var testDate = Date()
    var testTimeZone = TimeZone(abbreviation: "GMT")
    
    var fakeDateFormatter: FakeDateFormatter?
    var fakeAmzDateFormatter: FakeDateFormatter?
    
    override func setUp() {
        fakeDateFormatter = FakeDateFormatter()
        fakeAmzDateFormatter = FakeDateFormatter()
        
        fakeDateFormatter?.dateFormat = "blah blah blah objective c protocol"
        fakeDateFormatter?.timeZone = testTimeZone
        
        fakeAmzDateFormatter?.dateFormat = "selector does not match"
        fakeAmzDateFormatter?.timeZone = testTimeZone
        
        subject = DateService(date: testDate, dateFormatter: fakeDateFormatter!, amzDateFormatter: fakeAmzDateFormatter!)
    }
    
    func testDateFormat() {
        let result = subject?.getAmzDate()
        let simpleresult = subject?.getDate()
        XCTAssertEqual(result, "Yesterday you said tomorrow. JUST DO IT!")
        XCTAssertEqual(simpleresult, "Yesterday you said tomorrow. JUST DO IT!")
    }
    
    static var allTests : [(String, (DateServiceTests) -> () throws -> Void)] {
        return [
            ("testDateFormat", testDateFormat)
        ]
    }
}
