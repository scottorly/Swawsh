import Foundation

let accessKeyId = "AKIAIQQRR434HDMAKTKA"
let secretAccessKey = "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"

let swawsh = Swawsh.sharedInstance

if let authorization = swawsh.generateCredential(
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
{
    let url = URL(string: "https://ec2.amazonaws.com/?Action=DescribeRegions&Version=2013-10-15")
    var request = URLRequest(url: url!)
    request.addValue(authorization, forHTTPHeaderField: "Authorization")
    request.addValue(swawsh.getDate(), forHTTPHeaderField: "x-amz-date")
    request.addValue(Swawsh.emptyStringHash, forHTTPHeaderField:"x-amz-content-sha256")
    request.httpMethod = "GET"
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        print(error)
        print(response)
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print(responseString)
    }
    task.resume()
}

RunLoop.main.run()
