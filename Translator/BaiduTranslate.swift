//
//  BaiduTranslate.swift
//  Translator
//
//  Created by Zhixun Liu on 2020/12/30.
//

import Foundation

import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

func MD5(string: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        let md5Hex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
    }

func generateSignOfBaiduAPI(textToTranslate: String!, saltNumber: Int!, appID: String!, appKey: String!) -> String {
    let concatnation = "\(appID!)\(textToTranslate!)\(saltNumber!)\(appKey!)"
    return MD5(string: concatnation)
}

extension String {
    
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()+&")
        let _r = self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
        if var r = _r {
            r = r.replacingOccurrences(of: "+", with: "%2B")
                .replacingOccurrences(of: "&", with: "%26")
            return r
        }
        return nil
    }
}

func translateUsingBaiduTranslateAPIAsync(textToTranslate:String!, langFrom:String?, langTo:String?, appID: String?, appKey: String?, onComplete: @escaping (String)->(Void), onError: @escaping (Int, String)->(Void)) -> Void {
    if (appID == nil || appKey == nil) {
        onError(0, "UNAUTHORIZED USER");
        return
    }
    print("Baidu Translate APPID = \(appID!)")
    if (langFrom == nil || langTo == nil) {
        onError(9, "Internal Error: cannot choose language to translate into");
        return
    }
    
    let baseURL = "https://api.fanyi.baidu.com/api/trans/vip/translate?";
    
    // 处理待翻译的字符串
    let textToTranslate = textToTranslate.replacingOccurrences(of: "\r", with: " ")
        .replacingOccurrences(of: "\n", with: " ")
    // 生成随机盐
    let saltNumber = Int.random(in: 0...100000)
    
    // 生成签名
    let sign = generateSignOfBaiduAPI(textToTranslate: textToTranslate, saltNumber: saltNumber, appID: appID, appKey: appKey)
    
    let textToTranslatedEncoded = textToTranslate.encodeURIComponent()
    print("Encoded: \(textToTranslatedEncoded!)")
    // 拼接GET参
    let params = "q=\(textToTranslatedEncoded!)&from=\(langFrom!)&to=\(langTo!)&appid=\(appID!.encodeURIComponent()!)&salt=\(saltNumber)&sign=\(sign)"
    let urlToRequest = "\(baseURL)\(params)"
    
    let url: URL = URL(string: urlToRequest)!
    let request: NSURLRequest = NSURLRequest(url: url)
    let queue:OperationQueue = OperationQueue()
    NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: queue, completionHandler:{ (response: URLResponse?, data: Data?, error: Error?) -> Void in
        var ret:String = "";
        if data == nil {
            onError(-1, "Please check network connection.")
            return
        }
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                print("\(jsonResult)")
                if jsonResult["trans_result"] == nil {
                    if jsonResult["error_code"] == nil {
                        onError(0, "Unknown error")
                    }
                    else {
                        onError(0, jsonResult["error_msg"] as! String)
                    }
                    return
                }
                let h1 = jsonResult["trans_result"] as! [[String: String]]
                let h2 = h1[0] as! [String: String]
                let h3 = h2["dst"] as! String
                //let wI = NSMutableString( string: "\\u263a" )
                //CFStringTransform( wI, nil, "Any-Hex/Java" as NSString, true )
                //let r = wI as String
                ret = "\(h3)"
            }
        } catch let error as NSError {
            ret = "Error: \(error.localizedDescription) \ncode=\(error.code)\ndomain=\(error.domain)"
            onError(error.code, error.localizedDescription)
            return
        }
        onComplete(ret)
    })
}
