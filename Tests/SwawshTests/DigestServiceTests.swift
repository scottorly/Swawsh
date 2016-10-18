import XCTest

@testable import Swawsh

class DigestServiceTest: XCTestCase {
    
    var subject: DigestService?
    
    override func setUp() {
        subject = DigestService()
        super.setUp()
    }
    
    func testSigningKey() {
        let result = subject?.generateSigningKey(secret: "a secret", date: "YESTERDAY YOU SAID TOMORROW", awsRegion: "Make your dreams come true", awsService: "if you're tired of starting over stop giving up")
        XCTAssertEqual(result!, [110, 242, 168, 6, 23, 170, 164, 2, 109, 178, 44, 51, 241, 63, 60, 1, 218, 15, 59, 230, 156, 121, 172, 250, 109, 80, 203, 19, 198, 47, 214, 190])
    }
    
    func testDigestString() {
        let result = subject?.HMACDigestString(key: [1,3,3,7], update: "most people dream about success")
        XCTAssertEqual(result!, "50b0368b70037fd30739fd051bb5d9cbda03461804a53b0770f589354747eacf")
    }
    
    func testDigest() {
        let result = subject?.HMACDigest(key: [], update: "but you're going to work hard at it")
        XCTAssertEqual(result!, [101, 216, 131, 25, 15, 205, 113, 124, 175, 138, 253, 177, 170, 178, 16, 231, 228, 57, 111, 90, 255, 181, 134, 85, 40, 59, 45, 240, 16, 222, 61, 163])
    }
    
    func testsha256Digest() {
        let result = subject?.sha256Digest(string: "you;re going to go to the point that most people would quit")
        XCTAssertEqual(result!, "54adb6b0eb137c912c7a80f048bc0b4924dd21ac28ecb23b2582728a73696df4")
    }
    
    func testLowercaseHex() {
        let result = subject?.lowerCaseHexStringFrom(byteArray: [7,3,3,1])
        XCTAssertEqual(result, "07030301")
    }
    
    static var allTests: [(String, (DigestServiceTest) -> () throws -> Void)] {
        return [
            ("testSigningKey", testSigningKey)
        ]
    }
    
}
