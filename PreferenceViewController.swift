//
//  PreferenceViewController.swift
//  Translator
//
//  Created by Zhixun Liu on 2021/1/2.
//

import Cocoa

class PreferenceViewController: NSViewController {
    @IBOutlet weak var translateInto: NSPopUpButton!
    @IBOutlet weak var doNotTranslateWhenMeetChineseCharacter: NSButton!
    @IBOutlet weak var TranslatrIntoAnotherLanguage: NSButton!
    @IBOutlet weak var txtAppID: NSTextField!
    @IBOutlet weak var txtAppKey: NSSecureTextField!
    @IBOutlet weak var chkTopMost: NSButton!
    @IBOutlet weak var chkEveryDesktop: NSButton!
    @IBOutlet weak var chkLookupInDict: NSButton!
    
    override func viewDidAppear() {
        view.window?.level = .floating
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateInto.removeAllItems()
        let languages = constant__get_languages()
        let flags = constant__get_national_flags()
        translateInto.addItems(withTitles: languages.enumerated().map {
            (index, element) in
            return "\(flags[index]) \(element)";
        })
        
        // Load user defaults
        let defaults = UserDefaults.standard;
        txtAppID.stringValue = defaults.string(forKey: "API.ID") ?? ""
        txtAppKey.stringValue = defaults.string(forKey:  "API.Key") ?? ""
        translateInto.selectItem(at: defaults.integer(forKey: "translateInto"))
        self.selectTranslateInto(translateInto!)
        if defaults.integer(forKey: "whenMeetChineseCharacter") == 0 {
            doNotTranslateWhenMeetChineseCharacter.state = .on
        }
        else {
            TranslatrIntoAnotherLanguage.state = .on
        }
        chkTopMost.state = defaults.bool(forKey: "topMost") ? .on : .off
        chkEveryDesktop.state = defaults.bool(forKey: "everyDesktop") ? .on : .off
        chkLookupInDict.state = defaults.bool(forKey: "lookupDict") ? .on : .off
    }
    
    @IBAction func InputAppID(_ sender: Any) {
        print((sender as! NSTextField).stringValue)
        UserDefaults.standard.setValue((sender as! NSTextField).stringValue, forKey: "API.ID")
    }
    
    @IBAction func inputAppKey(_ sender: Any) {
        UserDefaults.standard.setValue((sender as! NSTextField).stringValue, forKey: "API.Key")
    }
    
    @IBAction func selectTranslateInto(_ sender: Any) {
        UserDefaults.standard.setValue(self.translateInto.indexOfSelectedItem, forKey: "translateInto")
        TranslatrIntoAnotherLanguage.title = "\(NSLocalizedString("Translate Into", comment: ""))\(self.translateInto.indexOfSelectedItem == 0 ? NSLocalizedString("English", comment: "") : constant__get_languages()[self.translateInto.indexOfSelectedItem])"
    }
    
    @IBAction func chooseChineseCharacterAction(_ sender: Any) {
        if let s = sender as? NSButton {
            UserDefaults.standard.setValue(s.tag, forKey: "whenMeetChineseCharacter")
        }
    }
    
    @IBAction func wangToLookUpInDict(_ sender: Any) {
        if let s = sender as? NSButton {
            UserDefaults.standard.setValue(s.state == .on, forKey: "lookupDict")
        }
    }
    
    @IBAction func changeIfStayOnTop(_ sender: Any) {
        if let s = sender as? NSButton {
            UserDefaults.standard.setValue(s.state == .on, forKey: "topMost")
        }
    }
    
    @IBAction func changeIfInEveryDesktop(_ sender: Any) {
        if let s = sender as? NSButton {
            UserDefaults.standard.setValue(s.state == .on, forKey: "everyDesktop")
        }
    }
}
