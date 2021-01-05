//
//  DictionaryAPI.swift
//  Translator
//
//  Created by Zhixun Liu on 2021/1/5.
//

import Foundation

func lookupDictionaryAsync(word:String!, onComplete: @escaping (String)->(Void), onError: @escaping (Int, String)->(Void)) {
    let baseURL = "https://apii.dict.cn/mini.php?"
    let urlToRequest = "\(baseURL)q=\(word ?? "")"
    
    let url: URL = URL(string: urlToRequest)!
    let request: NSURLRequest = NSURLRequest(url: url)
    let queue:OperationQueue = OperationQueue()
    NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: queue, completionHandler:{ (response: URLResponse?, data: Data?, error: Error?) -> Void in
        if data == nil {
            onError(-1, "Please check network connection.")
            return
        }
        let resultHTML = String(decoding: data!, as: UTF8.self)
        if resultHTML.contains("<span class='p'>"){
            onComplete(resultHTML)
            return
        }
        onError(-1, "Not found.")
    })
}
