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
        
        print("Enterring configure setting...")
        let defaults = UserDefaults.standard;
        print("done)")
        if (defaults.object(forKey: KEY_APP_ID) == nil) {
            defaults.setValue("", forKey: KEY_APP_ID)
        }
        if (defaults.object(forKey: KEY_APP_KEY) == nil) {
            defaults.setValue("", forKey: KEY_APP_KEY)
        }
        if (defaults.object(forKey: KEY_TRANSLATE_INTO) == nil) {
            defaults.setValue(0, forKey: KEY_TRANSLATE_INTO)
        }
        if (defaults.object(forKey: KEY_WHEN_MEET_CHINESE_CHARACTER) == nil) {
            defaults.setValue(0, forKey: KEY_WHEN_MEET_CHINESE_CHARACTER)
        }
        if (defaults.object(forKey: KEY_TOP_MOST) == nil) {
            defaults.setValue(true, forKey: KEY_TOP_MOST)
        }
        if (defaults.object(forKey: KEY_SHOW_ON_EVERY_DESKTOP) == nil) {
            defaults.setValue(true, forKey: KEY_SHOW_ON_EVERY_DESKTOP)
        }
        if (defaults.object(forKey: KEY_LOOKUP_DICT) == nil) {
            defaults.setValue(true, forKey: KEY_LOOKUP_DICT)
            print("set default KEY_LOOKUP_DICT to: \( defaults.bool(forKey: KEY_LOOKUP_DICT) )")
        }
        
        if (defaults.string(forKey: KEY_APP_ID) == "") {
            defaults.setValue("20160628000024160", forKey: KEY_APP_ID)
        }
        if (defaults.string(forKey: KEY_APP_KEY) == "") {
            defaults.setValue("835JS22N3C2PA4Brrrwo", forKey: KEY_APP_KEY)
        }
        
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

