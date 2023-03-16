import AppKit

extension MainWindowController {
    
    @IBAction func appearanceSelection(_ sender: Any) {
        
        if  let toolbarItemGroup = sender as? NSToolbarItemGroup {

            let appearance: NSAppearance.Name = toolbarItemGroup.selectedIndex == 0 ? .aqua : .darkAqua
            window?.appearance = NSAppearance(named: appearance)
        }
    }
    
    @IBAction  func printDocument(_ sender: Any) {
        
        let view = viewController.listTransactionsController?.outlineListView
        
        let headerLine = "Liste transactions"
        
        let printOpts: [NSPrintInfo.AttributeKey: Any] = [.headerAndFooter: true, .orientation: 1]
        let printInfo = NSPrintInfo(dictionary: printOpts)
        
        printInfo.leftMargin = 20
        printInfo.rightMargin = 20
        printInfo.topMargin = 40
        printInfo.bottomMargin = 20
        
        printInfo.horizontalPagination = .fit
        printInfo.verticalPagination = .automatic
        
        printInfo.scalingFactor = 1.0
        printInfo.paperSize = NSSize(width: 595, height: 842)
        
        let myPrintView = MyPrintViewOutline(tableView: view, andHeader: headerLine)
        
        let printTransaction = NSPrintOperation(view: myPrintView, printInfo: printInfo)
        printTransaction.printPanel.options.insert(NSPrintPanel.Options.showsPaperSize)
        printTransaction.printPanel.options.insert(NSPrintPanel.Options.showsOrientation)
        
        printTransaction.run()
        printTransaction.cleanUp()
    }
    
    @IBAction  func printBankStatement(_ sender: Any) {
        
        let view = viewController.listBankStatementController?.tableBankStatement
        
        let headerLine = "List Bank Statement"
        
        let printOpts: [NSPrintInfo.AttributeKey: Any] = [.headerAndFooter: true, .orientation: 0]
        let printInfo = NSPrintInfo(dictionary: printOpts)
        
        printInfo.leftMargin = 20
        printInfo.rightMargin = 20
        printInfo.topMargin = 40
        printInfo.bottomMargin = 20
        
        printInfo.horizontalPagination = .fit
        printInfo.verticalPagination = .automatic
        
        printInfo.scalingFactor = 1.0
        printInfo.paperSize = NSSize(width: 595, height: 842)
        
        let myPrintView = MyPrintViewTable(tableView: view, andHeader: headerLine)
        
        let printBankStatement = NSPrintOperation(view: myPrintView, printInfo: printInfo)
        printBankStatement.printPanel.options.insert(NSPrintPanel.Options.showsPaperSize)
        printBankStatement.printPanel.options.insert(NSPrintPanel.Options.showsOrientation)
        
        printBankStatement.showsPrintPanel = true
        printBankStatement.run()
        printBankStatement.cleanUp()
        
    }

    @objc func pageLayoutDidEnd( pageLayout: NSPageLayout?, returnCode: Int, contextInfo: UnsafeMutableRawPointer?) {
        if returnCode == Int(NSApplication.ModalResponse.OK.rawValue) {
        }
    }
    
    @IBAction func LaunchCalc(_ sender: Any) {
        
        var isAlreadyRunning = false
        let running = NSWorkspace.shared.runningApplications
        
        for app in running {
            let id = app.bundleIdentifier
            if id == "com.apple.calculator" {
                isAlreadyRunning = true
                break
            }
        }
        
        if isAlreadyRunning == false {
            guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.calculator") else { return }
            
            let configuration = NSWorkspace.OpenConfiguration()
            let path = "/bin"
            configuration.arguments = [path]
            NSWorkspace.shared.openApplication(at: url,
                                               configuration: configuration,
                                               completionHandler: nil)
                //            _ = NSWorkspace.shared.launchApplication(path!)
        }
    }
    
    @IBAction func showPreference(_ sender: Any) {
        
        preferencesWindowController.showWindow()
    }

    @IBAction func chooseCouleur(_ sender: NSMenuItem) {
        
        var title = ""

        let item = sender
        let tag = item.tag

        switch tag {
        case 1:
            title = "unie"
        case 2:
            title = "recette/depense"
        case 3:
            title = "rubrique"
        case 4:
            title = "mode"
        case 5:
            title = "statut"
            
        default:
            break
        }
        
        Defaults.set(title, forKey: "choix couleurs")
        Defaults.set(tag, forKey: "couleurMenus")

        // Loop thorugh all menu items and toggle on the selected item
        for item in colorMenu.items  {
            item.state = .off
        }
        sender.state = .on
        
        viewController.listTransactionsController?.resetChange()
        viewController.listTransactionsController?.reloadData(false, true)
        
    }
    
    @IBAction func AdvancedFilter(_ sender: Any) {
        
        viewController.changeView( "AdvancedFilterViewController")
    }
    
//    @IBAction func rateAppStore(_ sender: Any) {
//
//        let configure = RateConfigure()
//        configure.name = Localizations.RateConfigure.name
//        configure.icon = NSImage(named: NSImage.Name("AppIcon"))
//        configure.detailText = Localizations.RateConfigure.detailText
//        configure.likeButtonTitle = Localizations.RateConfigure.likeButtonTitle
//        configure.ignoreButtonTitle = Localizations.RateConfigure.ignoreButtonTitle
//        configure.rateURL = URL(string: "https://www.apple.com")
//
//        rateWindowController = RateWindowController(configure: configure)
//        rateWindowController?.nTimeout = 10
//        rateWindowController?.requestRateWindow(.center, with: { rlst in
//            print(String(format: "%lu", UInt(Float(rlst.rawValue))))
//        })
//    }
    
    
    func defaultDraftName(_ name: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH_mm_ss"
        let theDate = Date()
        let theDateString = dateFormatter.string(from: theDate)
        return name + theDateString
    }
    
    var export: String {
        get {
            return exportTmp
        }
        set {
            exportTmp += newValue
        }
    }
    
//    func createMenuForSearchField() {
//        let menu = NSMenu()
//            //        menu.title =  Localizations.searchMenu.title.menu
//
//        let allMenuItem = NSMenuItem()
//        allMenuItem.title =  Localizations.searchMenu.title.all
//        allMenuItem.target = self
//        allMenuItem.action = #selector(changeSearchFieldItem(_:))
//
//        let fNameMenuItem = NSMenuItem()
//        fNameMenuItem.title = Localizations.searchMenu.title.comment
//        fNameMenuItem.target = self
//        fNameMenuItem.action = #selector(changeSearchFieldItem(_:))
//
//        let cNameMenuItem = NSMenuItem()
//        cNameMenuItem.title = Localizations.searchMenu.title.category
//        cNameMenuItem.target = self
//        cNameMenuItem.action = #selector(changeSearchFieldItem(_:))
//
//        let rNameMenuItem = NSMenuItem()
//        rNameMenuItem.title = Localizations.searchMenu.title.rubric
//        rNameMenuItem.target = self
//        rNameMenuItem.action = #selector(changeSearchFieldItem(_:))
//
//        menu.removeAllItems()
//        menu.addItem(allMenuItem)
//        menu.addItem(fNameMenuItem)
//        menu.addItem(cNameMenuItem)
//        menu.addItem(rNameMenuItem)
//
//        self.searchField.searchMenuTemplate = menu
//        self.changeSearchFieldItem(allMenuItem)
//    }
//
    @objc func changeSearchFieldItem(_ sender: AnyObject) {
        (self.searchField.cell as? NSSearchFieldCell)?.placeholderString = sender.title
    }
}

extension MainWindowController: NSControlTextEditingDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        
        guard obj.object as? NSSearchField == searchField else { return }
        
        let searchString = self.searchField.stringValue
        var predicate  = NSPredicate()
        if searchString.isEmpty {
            viewController.listTransactionsController?.getAllData()
            viewController.listTransactionsController?.reloadData()
        } else {
            let p1 = NSPredicate(format: "account == %@", currentAccount!)
            let p2 = NSPredicate(format: "SUBQUERY(sousOperations, $sousOperation, $sousOperation.libelle CONTAINS[cd] %@).@count > 0", searchString)
            let p3 = NSPredicate(format: "SUBQUERY(sousOperations, $sousOperation, $sousOperation.category.name CONTAINS[cd] %@).@count > 0", searchString)
            let p4 = NSPredicate(format: "SUBQUERY(sousOperations, $sousOperation, $sousOperation.category.rubric.name CONTAINS[cd] %@).@count > 0", searchString)

            let placeHolder = (self.searchField.cell as? NSSearchFieldCell)?.placeholderString
            
            if placeHolder == Localizations.searchMenu.title.all {
                let p5 = NSCompoundPredicate(type: .or, subpredicates: [p2, p3, p4])
                predicate = NSCompoundPredicate(type: .and, subpredicates: [p1, p5])
            }
            
            if placeHolder == Localizations.searchMenu.title.comment {
                predicate = NSCompoundPredicate(type: .and, subpredicates: [p1, p2])
            }
            
            if placeHolder == Localizations.searchMenu.title.category {
                predicate = NSCompoundPredicate(type: .and, subpredicates: [p1, p3])
            }
            
            if placeHolder == Localizations.searchMenu.title.rubric {
                predicate = NSCompoundPredicate(type: .and, subpredicates: [p1, p4])
            }
            
            let fetchRequest = NSFetchRequest<EntityTransactions>(entityName: "EntityTransactions")
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateOperation", ascending: false)]
            
            viewController.listTransactionsController?.applyFilter( fetchRequest)
        }
    }
    
}

