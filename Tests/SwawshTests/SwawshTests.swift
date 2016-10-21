import XCTest
import Foundation

@testable import Swawsh

class FakeDateService: DateServiceProtocol {

    func getAmzDate() -> String {
        return "I am a really cool formatted date"
    }
    
    func getDate() -> String {
        return "simpler date format";
    }
}

class FakeDigestService: DigestServiceProtocol {
    
    var tooFiddySixwasCalled: Bool?
    
    func lowerCaseHexStringFrom(byteArray: [UInt8]) -> String {
        return "I PUT A HEX ON YOU"
    }
    
    var headerString: String?
    func sha256Digest(string: String) -> String? {
        headerString = string
        return "TooFiddySix"
    }
    
    func HMACDigest(key: [UInt8], update: String) -> [UInt8]? {
        return [32,12,32,72,32]
    }
    
    var expectedtSigningKey: [UInt8]?, expectedStringToSign: String?
    
    func HMACDigestString(key: [UInt8], update: String) -> String? {
        expectedtSigningKey = key
        expectedStringToSign = update
        return "H4$H3D"
    }
    
    var secretParameter, dateParameter, awsRegionParameter, awsServiceParameter: String?
    
    func generateSigningKey(secret: String, date: String, awsRegion: String, awsService: String) -> [UInt8] {
        secretParameter = secret
        dateParameter = date
        awsRegionParameter = awsRegion
        awsServiceParameter = awsService
        return [3,1,3,3,7,3]
    }
    
    func resetFake() {
        headerString = nil
        
        secretParameter = nil
        dateParameter = nil
        awsRegionParameter = nil
        awsServiceParameter = nil
        
        expectedtSigningKey = nil
        expectedStringToSign = nil
    }
}

class SwawshTests: XCTestCase {

    var fakeDigestService: FakeDigestService?
    var fakeDateService: FakeDateService?
    
    var subject: SwawshCredential?
    
    override func setUp() {
        super.setUp()
        fakeDigestService = FakeDigestService()
        fakeDateService = FakeDateService()
        subject = SwawshCredential(dateService: fakeDateService!, digestService: fakeDigestService!)
    }
    
    override func tearDown() {
        super.tearDown()
        fakeDigestService?.resetFake()
    }
    
    func testAuthorizationString() {
        let result = subject?.generateCredential(method: .GET, path: "a path", endPoint: "an endpoint", queryParameters: "", payloadDigest: "payload digest", region: "a region", service: "a service", accessKeyId: "my key", secretKey: "my secret key")
        
        XCTAssertEqual(fakeDigestService?.secretParameter!, "my secret key")
        XCTAssertEqual(fakeDigestService?.dateParameter!, "simpler date format")
        XCTAssertEqual(fakeDigestService?.awsRegionParameter!, "a region")
        XCTAssertEqual(fakeDigestService?.awsServiceParameter!, "a service")
        
        XCTAssertEqual((fakeDigestService?.expectedtSigningKey)!, [3,1,3,3,7,3])
        XCTAssertEqual(fakeDigestService?.expectedStringToSign!, "AWS4-HMAC-SHA256\nI am a really cool formatted date\nsimpler date format/a region/a service/aws4_request\nTooFiddySix")
        
        
        XCTAssertEqual(result!, "AWS4-HMAC-SHA256 Credential=my key/simpler date format/a region/a service/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=H4$H3D")
    }
    
    func testGetDate() {
        let date = subject?.getDate()
        XCTAssertEqual(date!, "I am a really cool formatted date")
    }
    
    static var allTests : [(String, (SwawshTests) -> () throws -> Void)] {
        return [
            ("testAuthorizationString", testAuthorizationString),
            ("testGetDate", testGetDate)
        ]
    }
}
