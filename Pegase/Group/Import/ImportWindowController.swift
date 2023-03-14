    //
    //  ImportWindowController.swift
    //  Pegase
    //
    //  Created by thierryH24 on 23/10/2021.
    //

import AppKit

struct HeaderColumnForMenu {
    var numCol: Int
    var nameCol: String
    var numMenu: Int
    var nameMenu: String
    
    init( numCol: Int, nameCol: String, numMenu: Int, nameMenu: String ) {
        self.numCol  = numCol
        self.nameCol  = nameCol
        self.numMenu  = numMenu
        self.nameMenu  = nameMenu
    }
}

class ImportWindowController: NSWindowController, NSSearchFieldDelegate {
    
    public var delegate: OperationsDelegate?

    
    @IBOutlet var anTableView: NSTableView!
    @IBOutlet var splitView: NSSplitView!
//    @IBOutlet weak var infoView: NSView!
    @IBOutlet var m_window: NSWindow!
    
    var menuHeader = NSMenu()
    
    var headerColumnForMenu = [HeaderColumnForMenu]()
    
    var statusBarFormatViewController: TTFormatViewController?
    
    var line = 0
    var nColumns = 0
    var url = ""
    
    var allData = [[String]]()
    var allDataRow = [[String]]()
    
    var dataLine = [String]()
    var headerData = [String]()
    var dataRow = [String]()
    var dataArray = [String]()
    
    var titles = [String]()
    
    var csvConfig =  CSV.Configuration()
    
    override var windowNibName: NSNib.Name? {
        return "ImportWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if statusBarFormatViewController == nil {
            statusBarFormatViewController = TTFormatViewController(nibName: NSNib.Name( "TTFormatViewController"), bundle: nil)
            statusBarFormatViewController?.delegate = self
            statusBarFormatViewController?.config = csvConfig
        }
        
//        infoView.isHidden = false
        
        splitView.addSubview((statusBarFormatViewController?.view)!, positioned: .above, relativeTo: splitView)
        statusBarFormatViewController?.selectFormatByConfig()
        
        setupHeaderMenu()
        readParseFile()
    }
    
    // Pops up the menu at the specified location.
    @IBAction func tableViewClick(_ sender: NSTableView) {
        
        let column = sender.clickedColumn
        let row    = sender.clickedRow
        
        guard column > -1, row == -1 else { return }
        
        let colRect = sender.headerView?.headerRect(ofColumn: column)
        
        let point = CGPoint(x: (colRect?.origin.x)!, y: (colRect?.origin.y)!)
        let menu = menuHeader
        menu.popUp( positioning: menu.item(at: 0), at: point, in: sender)
    }
    
    @IBAction func cancelImport(_ sender: NSButton) {
        self.close()
    }
    
    func readParseFile() {
        
        if let url = NSOpenPanel().selectUrl {
            
//            infoView.isHidden = true
            
            self.url = url.path
            let stream = InputStream(fileAtPath: self.url)
            
            let configuration = CSV.Configuration.detectConfiguration(url: url )!
            
            var config = statusBarFormatViewController?.config
            config?.delimiter = configuration.delimiter
            config?.isFirstRowAsHeader = true
            config?.isReverseSignAmountCheckBbox = false
            config?.encoding = configuration.encoding
            statusBarFormatViewController?.filePath.url = url
            
            statusBarFormatViewController?.config = config!
            statusBarFormatViewController?.selectFormatByConfig()
            
            let parser = CSV.Parser(inputStream: stream!, configuration: configuration)
            parser.delegate = self
            do {
                try parser.parse()
            } catch {
                print("Error fetching data from CSV")
            }
            setupHeaderMenu()
        } else {
            print("file selection was canceled")
        }
    }
    
    func resetListTransactions() {

        (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
        self.delegate?.getAllData()
        self.delegate?.reloadData(false, true)
        NotificationCenter.send(.updateBalance)
    }

    
}

//extension String {
//    public func removeFormatAmount() -> Double {
//        let formatter = NumberFormatter()
//        formatter.locale = Locale.current
//        formatter.numberStyle = .currency
//        formatter.currencySymbol = Locale.current.currencySymbol
//        formatter.decimalSeparator = Locale.current.groupingSeparator
//        return formatter.number(from: self)?.doubleValue ?? 0.00
//    }
//}

