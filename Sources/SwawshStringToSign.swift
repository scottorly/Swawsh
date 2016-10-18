import Foundation

struct SwawshStringToSign {
    let date: String
    let headerDigest: String
    let region: String
    let service: String
    let algorithim = "AWS4-HMAC-SHA256"
    let amzDate: String
    
    var value: String {
        return
            "\(algorithim)\n" +
            "\(amzDate)\n" +
            "\(date)/\(region)/\(service)/aws4_request\n" +
            headerDigest
    }
}
