//
//  MainWindowSideViewController.swift
//  Translator
//
//  Created by Zhixun Liu on 2020/12/30.
//

import Cocoa


class MainWindowSideViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "translateInto" {
            self.tableView.selectRowIndexes(IndexSet(integer: UserDefaults.standard.integer(forKey: "translateInto")), byExtendingSelection: false)
        }
    }
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.tableView.rowHeight = 25
        
        UserDefaults.standard.addObserver(self, forKeyPath: "translateInto", options: .new, context: nil)
        self.tableView.selectRowIndexes(IndexSet(integer: UserDefaults.standard.integer(forKey: "translateInto")), byExtendingSelection: false)
    }
    
    //选中某一行
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = self.tableView.selectedRow
        print("selected row \(row)")
        UserDefaults.standard.setValue(row, forKey: "translateInto")
    }
    
    
}

extension MainWindowSideViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        print("table view count ======== ")
        return constant__get_language_codes().count
    }
}

extension MainWindowSideViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LanguageCell"), owner: self) as! NSTableCellView
        cell.textField!.stringValue = "\(constant__get_national_flags()[row]) \(constant__get_languages()[row])"
        return cell;
    }
}
