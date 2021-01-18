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
    @IBOutlet weak var txtAppKey: NSTextField!
    @IBOutlet weak var chkTopMost: NSButton!
    @IBOutlet weak var chkEveryDesktop: NSButton!
    @IBOutlet weak var chkLookupInDict: NSButton!
    
    func assignUserDefaultsToWindowState(keyPath: String) {
        if keyPath == KEY_TOP_MOST {
            print(UserDefaults.standard.bool(forKey: KEY_TOP_MOST))
            view.window?.level = UserDefaults.standard.bool(forKey: KEY_TOP_MOST) ? .floating : .normal
        }
        else if keyPath == KEY_SHOW_ON_EVERY_DESKTOP {
            view.window?.collectionBehavior = UserDefaults.standard.bool(forKey: KEY_SHOW_ON_EVERY_DESKTOP) ? [ .canJoinAllSpaces] : [ .fullScreenNone ]
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == nil { return }
        assignUserDefaultsToWindowState(keyPath: keyPath!)
    }
    
    override func viewDidAppear() {
        assignUserDefaultsToWindowState(keyPath: "topMost")
        assignUserDefaultsToWindowState(keyPath: "everyDesktop")
        UserDefaults.standard.addObserver(self, forKeyPath: "topMost", options: .new, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: "everyDesktop", options: .new, context: nil)
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
        txtAppID.stringValue = defaults.string(forKey: KEY_APP_ID) ?? ""
        txtAppID.delegate = self
        txtAppKey.stringValue = defaults.string(forKey:  KEY_APP_KEY) ?? ""
        txtAppKey.delegate = self
        translateInto.selectItem(at: defaults.integer(forKey: KEY_TRANSLATE_INTO))
        self.selectTranslateInto(translateInto!)
        if defaults.integer(forKey: KEY_WHEN_MEET_CHINESE_CHARACTER) == 0 {
            doNotTranslateWhenMeetChineseCharacter.state = .on
        }
        else {
            TranslatrIntoAnotherLanguage.state = .on
        }
        chkTopMost.state = defaults.bool(forKey: KEY_TOP_MOST) ? .on : .off
        chkEveryDesktop.state = defaults.bool(forKey: KEY_SHOW_ON_EVERY_DESKTOP) ? .on : .off
        chkLookupInDict.state = defaults.bool(forKey: KEY_LOOKUP_DICT) ? .on : .off
    }
    
    @IBAction func selectTranslateInto(_ sender: Any) {
        UserDefaults.standard.setValue(self.translateInto.indexOfSelectedItem, forKey: KEY_TRANSLATE_INTO)
        TranslatrIntoAnotherLanguage.title = "\(NSLocalizedString("Translate Into", comment: ""))\(self.translateInto.indexOfSelectedItem == 0 ? NSLocalizedString("English", comment: "") : constant__get_languages()[self.translateInto.indexOfSelectedItem])"
    }
    
    @IBAction func chooseChineseCharacterAction(_ sender: Any) {
        if let s = sender as? NSButton {
            UserDefaults.standard.setValue(s.tag, forKey: KEY_WHEN_MEET_CHINESE_CHARACTER)
        }
    }
    
    @IBAction func wangToLookUpInDict(_ sender: Any) {
        if let s = sender as? NSButton {
            UserDefaults.standard.setValue(s.state == .on, forKey: KEY_LOOKUP_DICT)
        }
    }
    
    @IBAction func changeIfStayOnTop(_ sender: Any) {
        if let s = sender as? NSButton {
            UserDefaults.standard.setValue(s.state == .on, forKey: KEY_TOP_MOST)
        }
    }
    
    @IBAction func changeIfInEveryDesktop(_ sender: Any) {
        if let s = sender as? NSButton {
            UserDefaults.standard.setValue(s.state == .on, forKey: KEY_SHOW_ON_EVERY_DESKTOP)
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
            UserDefaults.standard.setValue(textField.stringValue, forKey: KEY_APP_ID)
            print(textField.stringValue)
        }
        else if let textField = obj.object as? NSTextField, self.txtAppKey.identifier == textField.identifier {
            UserDefaults.standard.setValue(textField.stringValue, forKey: KEY_APP_KEY)
            print(textField.stringValue)
        }
    }
}
