import Foundation

public enum Method: String {
    case GET, POST, PUT, DELETE
}

struct SwawshAuthorization {
    let algorithimKey = "AWS4-HMAC-SHA256 Credential="
    let header: SwaswshHeader
    let accesssKeyId: String
    let region: String
    let service: String
    let requestAuthorizationType = "aws4_request"
    let headersKey = "SignedHeaders="
    let signatureKey = "Signature="
    let signature: String
    
    var authorizationValue: String {
        return algorithimKey +
        "\(accesssKeyId)" +
        "/\(header.date)" +
        "/\(region)" +
        "/\(service)" +
        "/\(requestAuthorizationType), " +
        "\(headersKey)" +
        "\(header.headers), " +
        "\(signatureKey)" +
        "\(signature)"
    }
}

struct SwaswshHeader {
    let method: Method
    let resourcePath: String
    let endPoint: String
    let queryParameters: String
    let amzDate: String
    let date: String
    let payloadHeaderKey: String
    let dateHeaderKey: String
    let payloadDigest: String
    let headers = "host;x-amz-content-sha256;x-amz-date"
    var canonicalHeader: String {
        return
            "\(method)\n" +
            "\(resourcePath)\n" +
            "\(queryParameters)\n" +
            "host:\(endPoint)\n" +
            "x-amz-content-sha256:\(payloadDigest)\n" +
            "x-amz-date:\(amzDate)\n" +
            "\n" +
            "\(headers)\n" +
            "\(payloadDigest)"
    }
}
