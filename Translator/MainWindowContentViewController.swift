//
//  MainWindowContentViewController.swift
//  Translator
//
//  Created by Zhixun Liu on 2020/12/30.
//

import Cocoa
import WebKit
import AppKit

class MainWindowContentViewController: NSViewController {
    
    @IBOutlet weak var resultDisplay: WKWebView!
    
    var storedStringInPasteBoard: String = "";
    
    enum InterfaceStyle : String {
       case Dark, Light

       init() {
          let type = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
          self = InterfaceStyle(rawValue: type)!
        }
    }
    
    override func viewDidAppear() {
        view.window?.level = .floating
    }
    
    var shouldUpdateUI = false;
    var translatedResultToUpdate = "";
    var textToTranslateToUpdate = "";
    var lastPasteboardCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Load initial screen
        resultDisplay.setValue(true, forKey: "drawsTransparentBackground")
        let welcomeHTML = """
<html>
<body style="font-family: Times, 'Times New Roman', 'SongTi SC'; background: rgba(255, 255, 255, 0); color: #ff6699; text-align: center; -webkit-user-select: none; cursor: default !important;">
    <div style="font-size: 18px; position: absolute; height:80%; width: 100%; top: 0; left: 0; display: flex; justify-content: center; align-items: center; -webkit-user-select: none;">
        <p>MIYUKI TRANSLATOR</p>
    </div>
    <p style="font-size: 12px; color: #888; position: absolute; bottom: 10%; left: 0; width: 100%; -webkit-user-select: none;">BY MIYUKI, IN DECEMBER, 2020</p>
    <script>document.body.setAttribute('oncontextmenu', 'event.preventDefault();');</script>
</body>
</html>
"""
        resultDisplay.loadHTMLString(welcomeHTML, baseURL: nil)
        
        // Timer to update UI
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (t) in
            if !self.shouldUpdateUI {
                return
            }
            self.shouldUpdateUI = false
            // check theme
            let currentStyle = InterfaceStyle()
            let fontColor = currentStyle == InterfaceStyle.Light ? "#000" : "#fff"
            let backColor = currentStyle == InterfaceStyle.Light ? "(255,255,255,0.2)" : "(0,0,0,0.2)"
            
            let resultHTML = """
    <html>
    <head>
        <meta charset="utf-8"/>
        <style>pre { -webkit-user-select: text !important; cursor:text; white-space: pre-wrap;  border-radius: 9px; background: rgba\(backColor); padding: 10px; font-family: Times, 'Times New Roman', 'SongTi SC'; font-size: 15px;  word-wrap:break-word;  line-height:20px; }</style>
    </head>
    <body style="font-family: Times, 'Times New Roman', 'SongTi SC'; color: #ff6699; font-size: 15px; -webkit-user-select: none; cursor: default; padding: 8px;">
        <p style="">TRANSLATED TEXT:</p>
        <pre style="color: \(fontColor)">\(self.translatedResultToUpdate)</pre>
        <br/>
        <p style="">THE ORIGINAL TEXT:</p>
        <pre style="color: \(fontColor)">\(self.textToTranslateToUpdate)</pre>
        <script>document.body.setAttribute('oncontextmenu', 'event.preventDefault();');</script>
    </body>
    </html>
    """
            self.resultDisplay.loadHTMLString(resultHTML, baseURL: nil)
            //self.txtResultDisplay.scrollRangeToVisible(NSRange(location:0, length:0))
        }
        
        // Set timer to check clipbpard
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            let pccount = NSPasteboard.general.changeCount
            if self.lastPasteboardCount == pccount {
                return
            }
            self.lastPasteboardCount = pccount
            // read from clipboard
            let strInPasteboard = NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string)
            if let str = strInPasteboard {
                if str == "" || str == self.storedStringInPasteBoard {
                    return
                }
                // check theme
                let currentStyle = InterfaceStyle()
                let fontColor = currentStyle == InterfaceStyle.Light ? "#000" : "#fff"
                let backColor = currentStyle == InterfaceStyle.Light ? "(255,255,255,0.2)" : "(0,0,0,0.2)"
                
                self.storedStringInPasteBoard = str;
                let strToShow = str.replacingOccurrences(of: "\r", with: "")
                    .replacingOccurrences(of: "\n", with: "")
                    .replacingOccurrences(of: "&", with: "&amp;")
                    .replacingOccurrences(of: "<", with: "&lt;")
                    .replacingOccurrences(of: ">", with: "&gt;")
                
                let resultHTML = """
    <html>
    <head>
        <meta charset="utf-8"/>
        <style>pre { -webkit-user-select: text !important; cursor:text; white-space: pre-wrap;  border-radius: 9px; background: rgba\(backColor); padding: 10px; font-family: Times, 'Times New Roman', 'SongTi SC'; font-size: 15px; line-height:20px; word-wrap:break-word; }</style>
    </head>
    <body style="font-family: Times, 'Times New Roman', 'SongTi SC'; color: #ff6699; font-size: 15px; -webkit-user-select: none; cursor: default; padding: 8px;">
        <p style="">TRANSLATING:</p>
        <pre style="color: \(fontColor)88"><i>Translating, please wait...</i></pre>
        <br/>
        <p style="">THE ORIGINAL TEXT:</p>
        <pre style="color: \(fontColor)">\(strToShow)</pre>
        <script>document.body.setAttribute('oncontextmenu', 'event.preventDefault();');</script>
    </body>
    </html>
"""
                self.resultDisplay.loadHTMLString(resultHTML, baseURL: nil)
            
                
                // 判断是应该中文->英语还是英语->中文
                let charArr = str.unicodeScalars
                var nonAsciiCount = 0
                for char in charArr {
                    if !char.isASCII {
                        nonAsciiCount = nonAsciiCount + 1
                    }
                }
                let langTo:String = nonAsciiCount > charArr.count / 3 ? "en" : "zh"
                
                translateUsingBaiduTranslateAPIAsync(textToTranslate: str, langFrom: "auto", langTo: langTo, appID: "20160628000024160", appKey: "835JS22N3C2PA4Brrrwo", onComplete: { (ret: String) in
                    let translatedResult = ret.replacingOccurrences(of: "<", with: "&lt;")
                            .replacingOccurrences(of: ">", with: "&gt;")
                    self.textToTranslateToUpdate = strToShow
                    self.translatedResultToUpdate = translatedResult
                    self.shouldUpdateUI = true
                    }
                )
            }
        }
    }
}
