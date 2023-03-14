    //
    //  MainWindowContoller.swift
    //  MainWindowContoller
    //
    //  Created by thierryH24 on 19/09/2021.
    //

import AppKit


class MainWindowController: NSWindowController {


    var actionsMenu: NSMenu = {
        var menu = NSMenu(title: "")
        let menuItem1 = NSMenuItem(title: "Light", action: #selector(appearanceSelection(_:)), keyEquivalent: "")
        let menuItem2 = NSMenuItem(title: "Dark", action: #selector(appearanceSelection(_:)), keyEquivalent: "")
        menu.items = [menuItem1, menuItem2]
        return menu
    }()
    
    var colorMenu: NSMenu = {
        var menu = NSMenu(title: "")
        var title = ""
        
        let menuItem0 = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        menuItem0.tag = 0
        
        menuItem0.image = NSImage(named: NSImage.colorPanelName)
        
        title =  Localizations.chooseColor.unie
        let menuItem1 = NSMenuItem(title: title, action: #selector(chooseCouleur(_:)), keyEquivalent: "")
        menuItem1.tag = 1

        title =  Localizations.chooseColor.income
        let menuItem2 = NSMenuItem(title: title, action: #selector(chooseCouleur(_:)), keyEquivalent: "")
        menuItem2.tag = 2

        title =  Localizations.chooseColor.rubric
        let menuItem3 = NSMenuItem(title: title, action: #selector(chooseCouleur(_:)), keyEquivalent: "")
        menuItem3.tag = 3

        title =  Localizations.chooseColor.mode
        let menuItem4 = NSMenuItem(title: title, action: #selector(chooseCouleur(_:)), keyEquivalent: "")
        menuItem4.tag = 4

        title =  Localizations.chooseColor.statut
        let menuItem5 = NSMenuItem(title: title, action: #selector(chooseCouleur(_:)), keyEquivalent: "")
        menuItem5.tag = 5

        menu.items = [menuItem0, menuItem1, menuItem2, menuItem3, menuItem4, menuItem5]
        
        let tag = Defaults.integer(forKey: "couleurMenus")
        let item = menu.item(withTag: tag)
        item?.state = .on

        return menu
    }()
    
    var searchMenu: NSMenu = {
        let allMenuItem = NSMenuItem()
        allMenuItem.title =  Localizations.searchMenu.title.all
        allMenuItem.action = #selector(changeSearchFieldItem(_:))
        
        let fNameMenuItem = NSMenuItem()
        fNameMenuItem.title = Localizations.searchMenu.title.comment
        fNameMenuItem.action = #selector(changeSearchFieldItem(_:))
        
        let cNameMenuItem = NSMenuItem()
        cNameMenuItem.title = Localizations.searchMenu.title.rubric
        cNameMenuItem.action = #selector(changeSearchFieldItem(_:))
        
        let rNameMenuItem = NSMenuItem()
        rNameMenuItem.title = Localizations.searchMenu.title.category
        rNameMenuItem.action = #selector(changeSearchFieldItem(_:))
        
        var menu = NSMenu(title: "")
        menu.removeAllItems()
        menu.addItem(allMenuItem)
        menu.addItem(fNameMenuItem)
        menu.addItem(cNameMenuItem)
        menu.addItem(rNameMenuItem)
        return menu
    }()
    
    // MARK: - Window Lifecycle
    
    var viewController : ViewController!
    
//    @IBOutlet weak var splitViewPrincipal: NSSplitView!
//    @IBOutlet weak var splitViewGauche: NSSplitView!
//    @IBOutlet weak var splitViewCentre: NSSplitView!
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var colorPopUp: NSPopUpButton!
    
    var importWindowController                 : ImportTransactionsWindowController?
    var importBankStatementWindowController    : ImportBankStatementWindowController?
    var importSchedulersWindowController       : ImportSchedulersWindowController?
    var accessoryViewController                : TTFormatViewController?
    
    var delimiter = ""
    var quote = ""
    var exportTmp = ""
    
    let preferencesWindowController = PreferencesWindowController(
        viewControllers: [
            GeneralViewController() ,
            AccountViewController() ,
            PersonViewController()
        ]
    )

    override func windowDidLoad() {
        super.windowDidLoad()
                
        viewController = self.contentViewController! as? ViewController

        setUpPopUpColor()
                
        for window in NSApp.windows {
            if let splashScreenWindow = window.windowController as? SplashScreenWindowController {
                splashScreenWindow.close()
            }
        }
        
        self.configureToolbar()
        searchField.delegate = self
    }
}

// MARK: - Search Field Delegate
extension MainWindowController: NSSearchFieldDelegate
{
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        print("Search field did start receiving input")
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        print("Search field did end receiving input")
        sender.resignFirstResponder()
    }
}

// MARK: - Sharing Service Picker Toolbar Item Delegate

extension MainWindowController: NSSharingServicePickerToolbarItemDelegate
{
    func items(for pickerToolbarItem: NSSharingServicePickerToolbarItem) -> [Any] {
        // Compose an array of items that are sharable such as text, URLs, etc.
        // depending on the context of your application (i.e. what the user
        // current has selected in the app and/or they tab they're in).
        let sharableItems = [URL(string: "https://www.apple.com/")!]
        return sharableItems
    }
}
