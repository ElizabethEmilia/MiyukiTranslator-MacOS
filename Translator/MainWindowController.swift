//
//  MainWindowController.swift
//  Translator
//
//  Created by Zhixun Liu on 2020/12/30.
//

import Cocoa

class MainWindowController: NSWindowController {
    @IBOutlet weak var toolbarItem_Preferences: NSToolbarItem!
    
    @IBOutlet weak var toolBarItemSearch: NSSearchToolbarItem!
    
    @IBOutlet weak var txtLookUp: NSSearchField!
    
    var lastTyped = ""
    
    @IBAction func toolbarItem_Search_action(_ sender: Any) {
        print("currently typed: \(txtLookUp.stringValue)")
        let currTyped = txtLookUp.stringValue;
        if currTyped != lastTyped {
            lastTyped = currTyped
            return
        }
        print("-- bingo! \(currTyped)")
        lastTyped = ""
        txtLookUp.stringValue = ""
        
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(currTyped, forType: NSPasteboard.PasteboardType.string)
        
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
