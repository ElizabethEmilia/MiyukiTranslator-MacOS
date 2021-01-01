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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
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

