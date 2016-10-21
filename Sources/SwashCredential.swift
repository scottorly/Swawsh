import Foundation

public class SwawshCredential {
    public static let emptyStringHash = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    let dateService: DateServiceProtocol
    let digestService: DigestServiceProtocol

    init(dateService: DateServiceProtocol, digestService: DigestServiceProtocol) {
        self.dateService = dateService
        self.digestService = digestService
    }
    
    let dateFormatter = DateFormatter()
    let amzDateFormatter = DateFormatter()
    let timeZone = TimeZone(abbreviation: "GMT")
    
    public static let sharedInstance = SwawshCredential(
        dateService: DateService(
            date: Date(),
            dateFormatter: DateFormatter.dateFormatterFactory(),
            amzDateFormatter: DateFormatter.amzDateFormatterFactory()
        ),
        digestService: DigestService()
    )
    
    public func getDate() -> String {
        return dateService.getAmzDate()
    }
    
    public func generateCredential(method: Method,
                            path: String,
                            endPoint: String,
                            queryParameters: String,
                            payloadDigest: String,
                            region: String,
                            service: String,
                            accessKeyId: String,
                            secretKey: String) -> String? {
        
        let header = SwaswshHeader(
            method: method,
            resourcePath: path,
            endPoint: endPoint,
            queryParameters: queryParameters,
            amzDate: dateService.getAmzDate(),
            date: dateService.getDate(),
            payloadHeaderKey: "",
            dateHeaderKey: "",
            payloadDigest: payloadDigest
        )
        
        guard let headerDigest = digestService.sha256Digest(string: header.canonicalHeader) else {
            return nil
        }
        
        let stringToSign = SwawshStringToSign(
            date: header.date,
            headerDigest: headerDigest,
            region: region,
            service: service,
            amzDate: header.amzDate
        )
        
        let signingKey = digestService.generateSigningKey(
            secret: secretKey,
            date: header.date,
            awsRegion: region,
            awsService: service
        )
        
        guard let signature = digestService.HMACDigestString(key: signingKey, update: stringToSign.value) else {
            return nil
        }
        
        let authorization = SwawshAuthorization(
            header: header,
            accesssKeyId: accessKeyId,
            region: region,
            service: service,
            signature: signature)
        
        return authorization.authorizationValue
    }    
}
