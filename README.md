# Swawsh

A cross platform library for signing AWS Signature Version 4 requests written in Swift.

http://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html

### Ec2 Example (macOS)
```swift
let swawsh = Swawsh.sharedInstance
let authorization = swawsh.generateCredential(
    method: .GET,
    path: "/",
    endPoint: "ec2.amazonaws.com",
    queryParameters: "Action=DescribeRegions&Version=2013-10-15",
    payloadDigest: Swawsh.emptyStringHash,
    region: "us-east-1",
    service: "ec2",
    accessKeyId: accessKeyId,
    secretKey: secretAccessKey
    )
let url = URL(string: "https://ec2.amazonaws.com/?Action=DescribeRegions&Version=2013-10-15")
var request = URLRequest(url: url!)
request.httpMethod = "GET"
request.addValue(authorization!, forHTTPHeaderField: "Authorization")
request.addValue(swawsh.getDate(), forHTTPHeaderField: "x-amz-date")
request.addValue(Swawsh.emptyStringHash, forHTTPHeaderField:"x-amz-content-sha256")
request.addValue("ec2.amazonaws.com", forHTTPHeaderField: "Host")

let session = URLSession.shared
let task = session.dataTask(with: request) { data, response, error in
    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
    print(responseString)
}
task.resume()
```

### S3 upload example
```swift
import Cryptor

let swawsh = Swawsh.sharedInstance
let uploadData = Data()
let sha256 = Digest(using: .sha256)
let digest = sha256.update(data: uploadData)?.final()
let digestHexString = CryptoUtils.hexString(from: digest!)

let authorization = swawsh.generateCredential(
    method: .PUT,
    path: "/my.awesome.bucket/text.txt",
    endPoint: "s3.amazonaws.com",
    queryParameters: "",
    payloadDigest: digestHexString,
    region: "us-east-1",
    service: "s3",
    accessKeyId: accessKeyId,
    secretKey: secretAccessKey
    )
{

let url = URL(string: "https://s3.amazonaws.com/my.awesome.bucket/text.txt")
var request = URLRequest(url: url!)
request.addValue(authorization!, forHTTPHeaderField: "Authorization")
request.addValue(swawsh.getDate(), forHTTPHeaderField: "x-amz-date")
request.addValue(digestHexString, forHTTPHeaderField:"x-amz-content-sha256")
request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
request.httpMethod = "PUT"

let session = URLSession.shared
let task = session.uploadTask(with: request, from: uploadData) { (data, response, error) in
    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
    print(responseString)
}
task.resume()
```
