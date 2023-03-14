//
//  MainWindowControllerToolBar.swift
//  Pegase
//
//  Created by thierryH24 on 12/11/2022.
//

import AppKit


extension MainWindowController {
    
    // MARK: - Toolbar Validation
    
    
    func configureToolbar()
    {
        if  let window = self.window {
            
            let newToolbar = NSToolbar(identifier: NSToolbar.Identifier.mainWindowToolbarIdentifier)
            newToolbar.delegate = self
            newToolbar.allowsUserCustomization = true
            newToolbar.autosavesConfiguration = true
            newToolbar.displayMode = .default
            
            // Example on center-pinning a toolbar item
            newToolbar.centeredItemIdentifier = NSToolbarItem.Identifier.toolbarLightDarItem
            
            window.title = "My Great App"
            if #available(macOS 11.0, *) {
                window.subtitle = "Toolbar Example"
                // The toolbar style is best set to .automatic
                // But it appears to go as .unifiedCompact if
                // you set as .automatic and titleVisibility as
                // .hidden
                window.toolbarStyle = .automatic
            }
            
            // Hiding the title visibility in order to gain more toolbar space.
            // Set this property to .visible or delete this line to get it back.
            window.titleVisibility = .visible
            
            window.toolbar = newToolbar
            window.toolbar?.validateVisibleItems()
        }
    }
    
    
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool
    {
        //         print("Validating \(item.itemIdentifier)")
        
        // Use this method to enable/disable toolbar items as user takes certain
        // actions. For example, so items may not be applicable if a certain UI
        // element is selected. This is called on your behalf. Return false if
        // the toolbar item needs to be disabled.
        
        //  Maybe you want to not enable more actions if nothing in your app
        //  is selected. Set your condition inside this `if`.
        if  item.itemIdentifier == NSToolbarItem.Identifier.toolbarMoreActions {
            return true
        }
        
        //  Maybe you want to not enable the share menu if nothing in your app
        //  is selected. Set your condition inside this `if`.
        if  item.itemIdentifier == NSToolbarItem.Identifier.toolbarShareButtonItem {
            return true
        }
        
        //  Example of returning false to demonstrate a disabled toolbar item.
        if  item.itemIdentifier == NSToolbarItem.Identifier.toolbarItemMoreInfo {
            return false
        }
        
        //          Feel free to add more conditions for your other toolbar items here...
        
        return true
    }
    
    // MARK: - Public static helper methods
    
    /// Returns the current window's document path
    public static func getCurrentDocument() -> String? {
        guard
            let window = NSApp.keyWindow?.windowController as? MainWindowController,
            let doc = window.document as? Document
        else { return nil }
        
        let path = doc.fileURL?.relativePath
        return path
    }
    
    func setUpPopUpColor() {
        var tag = Defaults.integer(forKey: "couleurMenus")
        if tag == 0 {
            tag = 1
            Defaults.set(tag, forKey: "couleurMenus")
            Defaults.set("unie", forKey: "choix couleurs")
        }
        
        let itemArray = colorPopUp.itemArray
        for item in itemArray {
            item.state = .off
            if item.tag == tag {
                item.state = .on
            }
        }
    }
    
    // MARK: - Toolbar Item Custom Actions
    @IBAction func testAction(_ sender: Any)
    {
        if  let toolbarItem = sender as? NSToolbarItem {
            print("Clicked \(toolbarItem.itemIdentifier.rawValue)")
        }
    }
}
