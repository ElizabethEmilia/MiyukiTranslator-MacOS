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
    var occursError = false;
    var errorMsg = "";
    
    var translatedResultToUpdate = "";
    var textToTranslateToUpdate = "";
    var lastPasteboardCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Load initial screen
        resultDisplay.setValue(true, forKey: "drawsTransparentBackground")
        let welcomeHTML = ui_template__main_page()
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
            
            if !self.occursError {
                let resultHTML = ui_template_display_result(backColor: backColor, fontColor: fontColor, originalText: self.textToTranslateToUpdate, resultText: self.translatedResultToUpdate)
                self.resultDisplay.loadHTMLString(resultHTML, baseURL: nil)
            }
            else {
                self.occursError = false
                let resultHTML = ui_template__process_info(backColor: backColor, fontColor: fontColor, originalText: self.textToTranslateToUpdate, title: "ERROR", message: self.errorMsg)
                self.resultDisplay.loadHTMLString(resultHTML, baseURL: nil)
            }
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
                
                let resultHTML = ui_template__process_info(backColor: backColor, fontColor: fontColor, originalText: strToShow, title: "TRANSLATING", message: "Translating, please wait...")
                    
                // 判断是应该中文->英语还是英语->中文
                let charArr = str.unicodeScalars
                var nonAsciiCount = 0
                for char in charArr {
                    if !char.isASCII {
                        nonAsciiCount = nonAsciiCount + 1
                    }
                }
                
                let isInChinese = nonAsciiCount > charArr.count / 3
                let doNotTranslateIfInChinese = UserDefaults.standard.integer(forKey: "whenMeetChineseCharacter") == 0
                let translateToAnotherLanguage = !doNotTranslateIfInChinese
                
                if isInChinese && doNotTranslateIfInChinese {
                    return
                }
                
                // Display translating UI message
                self.resultDisplay.loadHTMLString(resultHTML, baseURL: nil)
            
                let currLangCode = getCurrentLanguageCode()
                var langTo = isInChinese ? currLangCode : "zh"
                if isInChinese && currLangCode == "zh" {
                    langTo = "en"
                }
                print("language to: \(langTo)")
                
                translateUsingBaiduTranslateAPIAsync(textToTranslate: str, langFrom: "auto", langTo: langTo, appID: UserDefaults.standard.string(forKey: "API.ID"), appKey: UserDefaults.standard.string(forKey: "API.Key"),
                    onComplete: { (ret: String) in
                        let translatedResult = ret.replacingOccurrences(of: "<", with: "&lt;")
                                .replacingOccurrences(of: ">", with: "&gt;")
                        self.textToTranslateToUpdate = strToShow
                        self.translatedResultToUpdate = translatedResult
                        self.shouldUpdateUI = true
                    },
                
                // handle error
                onError: { (errCode: Int, errmsg: String) in
                    var errorMessage = errmsg
                    if errmsg == "UNAUTHORIZED USER" {
                        errorMessage = "Baidu Translated API ID is incorrect, please go to perference (press command+,) and set Baidu API ID and Secret Key then retry. If you don't have any, you can obtain one from Baidu Translate Offical Site. <br><br> For more information, see &lt;https://fanyi-api.baidu.com/doc/13&gt;";
                    }
                    else if errmsg == "Invalid Sign" {
                        errorMessage = "Please check if your API ID and/or secret key is correct and retry."
                    }
                    self.textToTranslateToUpdate = strToShow
                    self.translatedResultToUpdate = ""
                    self.errorMsg = errorMessage
                    self.occursError = true
                    self.shouldUpdateUI = true
                })
            }
        }
    }
}
