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
    @IBOutlet var txtResultDisplay: NSTextView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Load initial screen
        let welcomeHTML:Data! = """
<html>
<body style="font-family: Times, 'Times New Roman', 'SongTi SC'; background: #CCC; color: #ff6699; text-align: center;">
    <p style="font-size: 18px;"><br/><br/><br/><br/><br/><br/><br/><br/>MIYUKI TRANSLATOR<br/><br/><br/><br/><br/><br/><br/><br/></p>
    <p style="font-size: 12px; color: #888"><br/><br/><br/><br/><br/>BY MIYUKI, IN DECEMBER, 2020</p>
</body>
</html>
""".data(using: String.Encoding.utf8);
        txtResultDisplay.textStorage!.setAttributedString(NSAttributedString(html: welcomeHTML, documentAttributes: nil)!)
        
        // Set timer to check clipbpard
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            // read from clipboard
            let strInPasteboard = NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string)
            if let str = strInPasteboard {
                if str == "" || str == self.storedStringInPasteBoard {
                    return
                }
                // check theme
                let currentStyle = InterfaceStyle()
                let fontColor = currentStyle == InterfaceStyle.Light ? "#000" : "#fff"
                
                self.storedStringInPasteBoard = str;
                let resultHTML:Data! = """
        <html>
        <head>
            <meta charset="utf-8"/>
            <style>pre { font-family: Times, 'Times New Roman', 'SongTi SC'; font-size: 15px; }</style>
        </head>
        <body style="font-family: Times, 'Times New Roman', 'SongTi SC'; color: #ff6699; font-size: 15px;">
            <p style="">TRANSLATING...</p>
            <br/>
            <p style="">THE ORIGINAL TEXT:</p>
            <pre style="color: \(fontColor)">\(str)</pre>
        </body>
        </html>
        """.data(using: String.Encoding.utf8);
                self.txtResultDisplay.textStorage!.setAttributedString(NSAttributedString(html: resultHTML, documentAttributes: nil)!)
                self.txtResultDisplay.scrollRangeToVisible(NSRange(location:0, length:0))
                
                // 判断是应该中文->英语还是英语->中文
                let charArr = str.unicodeScalars
                var nonAsciiCount = 0
                for char in charArr {
                    if !char.isASCII {
                        nonAsciiCount = nonAsciiCount + 1
                    }
                }
                let langTo:String = nonAsciiCount > charArr.count / 2 ? "en" : "zh"
                
                translateUsingBaiduTranslateAPIAsync(textToTranslate: str, langFrom: "auto", langTo: langTo, appID: "20160628000024160", appKey: "835JS22N3C2PA4Brrrwo", onComplete: { (ret: String) in
                        let translatedResult = ret
                        let resultHTML:Data! = """
                <html>
                <head>
                    <meta charset="utf-8"/>
                    <style>pre { font-family: Times, 'Times New Roman', 'SongTi SC'; font-size: 15px; }</style>
                </head>
                <body style="font-family: Times, 'Times New Roman', 'SongTi SC'; color: #ff6699; font-size: 15px;">
                    <p style="">TRANSLATED TEXT:</p>
                    <pre style="color: \(fontColor)">\(translatedResult)</pre>
                    <br/>
                    <p style="">THE ORIGINAL TEXT:</p>
                    <pre style="color: \(fontColor)">\(str)</pre>
                </body>
                </html>
                """.data(using: String.Encoding.utf8);
                        self.txtResultDisplay.textStorage!.setAttributedString(NSAttributedString(html: resultHTML, documentAttributes: nil)!)
                        //self.txtResultDisplay.scrollRangeToVisible(NSRange(location:0, length:0))
                    }
                )
            }
        }
    }
    
}
