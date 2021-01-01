//
//  PreferenceViewController.swift
//  Translator
//
//  Created by Zhixun Liu on 2021/1/2.
//

import Cocoa

class PreferenceViewController: NSViewController {
    @IBOutlet weak var txtAppID: NSTextField!
    @IBOutlet weak var txtAppKey: NSSecureTextField!
    @IBOutlet weak var translateInto: NSPopUpButton!
    @IBOutlet weak var doNotTranslateWhenMeetChineseCharacter: NSButton!
    @IBOutlet weak var TranslatrIntoAnotherLanguage: NSButton!
    
    override func viewDidAppear() {
        view.window?.level = .floating
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateInto.removeAllItems()
        let languages = constant__get_languages()
        translateInto.addItems(withTitles: languages)
        
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
    }
    
    @IBAction func InputAppID(_ sender: Any) {
        UserDefaults.standard.setValue((sender as! NSTextField).stringValue, forKey: "API.ID")
    }
    
    @IBAction func inputAppKey(_ sender: Any) {
        UserDefaults.standard.setValue((sender as! NSTextField).stringValue, forKey: "API.Key")
    }
    
    @IBAction func selectTranslateInto(_ sender: Any) {
        UserDefaults.standard.setValue(self.translateInto.indexOfSelectedItem, forKey: "translateInto")
        TranslatrIntoAnotherLanguage.title = "Translate into \(self.translateInto.indexOfSelectedItem == 0 ? "English" : constant__get_languages()[self.translateInto.indexOfSelectedItem])"
    }
    
    @IBAction func chooseChineseCharacterAction(_ sender: Any) {
        if let s = sender as? NSButton {
            UserDefaults.standard.setValue(s.tag, forKey: "whenMeetChineseCharacter")
        }
    }
    
}
