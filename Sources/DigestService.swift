import Foundation
import Cryptor

protocol DigestServiceProtocol {
    func lowerCaseHexStringFrom(byteArray: [UInt8]) -> String
    func sha256Digest(string: String) -> String?
    func HMACDigest(key: [UInt8], update: String) -> [UInt8]?
    func HMACDigestString(key: [UInt8], update: String) -> String?
    func generateSigningKey(secret: String, date: String, awsRegion: String, awsService: String) -> [UInt8]
}

class DigestService: DigestServiceProtocol {
    
    func lowerCaseHexStringFrom(byteArray: [UInt8]) -> String {
        return CryptoUtils.hexString(from: byteArray, uppercase: false)
    }
    
    func sha256Digest(string: String) -> String? {
        let sha256 = Digest(using: .sha256)
        guard let digest = sha256.update(string: string)?.final() else {
            return nil
        }
        let digestHexString = lowerCaseHexStringFrom(byteArray: digest)
        return digestHexString
    }
    
    func HMACDigest(key: [UInt8], update: String) -> [UInt8]? {
        guard let hmacDigest = HMAC(using: HMAC.Algorithm.sha256, key: key).update(string: update)?.final() else {
            return nil
        }
        return hmacDigest
    }
    
    func HMACDigestString(key: [UInt8], update: String) -> String? {
        guard let hmacDigest = HMACDigest(key: key, update: update) else { return nil }
        let digestHexString = lowerCaseHexStringFrom(byteArray: hmacDigest)
        return digestHexString
    }
    
    func generateSigningKey(secret: String, date: String, awsRegion: String, awsService: String) -> [UInt8] {
        let awsSecretKey = "AWS4" + secret
        let secretKey = CryptoUtils.byteArray(from: awsSecretKey)
        let dateKey = HMACDigest(key: secretKey, update: date)
        let dateRegionKey = HMACDigest(key: dateKey!, update: awsRegion)
        let dateRegionServiceKey = HMACDigest(key: dateRegionKey!, update: awsService)
        let signingKey = HMACDigest(key: dateRegionServiceKey!, update: "aws4_request")
        return signingKey!
    }
}
