//
//  PreferenceViewController.swift
//  Translator
//
//  Created by Zhixun Liu on 2021/1/2.
//

import Cocoa

class PreferenceViewController: NSViewController, NSTextFieldDelegate {
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
        txtAppID.delegate = self
        txtAppKey.stringValue = defaults.string(forKey:  "API.Key") ?? ""
        txtAppKey.delegate = self
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
    
    @IBAction func helpButtonClick(_ sender: Any) {
        let url = URL(string: NSLocalizedString("help_url", comment: ""))!
        if NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
    
    func controlTextDidChange(_ obj: Notification) {
        print("edited: ")
        if let textField = obj.object as? NSTextField, self.txtAppID.identifier == textField.identifier {
            UserDefaults.standard.setValue(textField.stringValue, forKey: "API.ID")
            print(textField.stringValue)
        }
        else if let textField = obj.object as? NSTextField, self.txtAppKey.identifier == textField.identifier {
            UserDefaults.standard.setValue(textField.stringValue, forKey: "API.Key")
            print(textField.stringValue)
        }
    }
}
