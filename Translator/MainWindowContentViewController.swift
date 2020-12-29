//
//  MainWindowContentViewController.swift
//  Translator
//
//  Created by Zhixun Liu on 2020/12/30.
//

import Cocoa
import WebKit

class MainWindowContentViewController: NSViewController {
    @IBOutlet var txtResultDisplay: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Load initial screen
        let welcomeHTML:Data! = """
<html>
<body style="font-family: Times, 'Times New Roman', 'SongTi SC'; background: #CCC; color: #ff6699; text-align: center;">
    <p style="font-size: 18px;"><br/><br/><br/>MIYUKI TRANSLATOR</p>
    <p style="font-size: 12px; color: #888"><br/><br/><br/><br/>BY MIYUKI, IN DECEMBER, 2020</p>
</body>
</html>
""".data(using: String.Encoding.utf8);
        txtResultDisplay.textStorage!.setAttributedString(NSAttributedString(html: welcomeHTML, documentAttributes: nil)!)
    }
    
}
