//
//  AppDelegate.swift
//  Translator
//
//  Created by Zhixun Liu on 2020/12/30.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var menuItemPreferences: NSMenuItem!
    var preferenceWindowController: PreferenceWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Initialize user defaults
        let defaults = UserDefaults.standard;
        defaults.setValue("", forUndefinedKey: "API.ID")
        defaults.setValue("", forUndefinedKey: "API.Key")
        defaults.setValue(0, forUndefinedKey: "translateInto")
        defaults.setValue(0, forUndefinedKey: "whenMeetChineseCharacter")
        defaults.setValue(true, forUndefinedKey: "topMost")
        defaults.setValue(true, forUndefinedKey: "everyDesktop")
        defaults.setValue(true, forUndefinedKey: "lookupDict")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func viewOnGitHub(_ sender: Any) {
        let url = URL(string: "https://github.com/ElizabethEmilia/MiyukiTranslator-MacOS")!
        if NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")

        }
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    @IBAction func openPreferenceWindow(_ sender: Any) {
        let mainStoryboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        self.preferenceWindowController = mainStoryboard.instantiateController(identifier: NSStoryboard.SceneIdentifier("PreferenceWindow"))
        self.preferenceWindowController!.showWindow(self)
    }
    
}

