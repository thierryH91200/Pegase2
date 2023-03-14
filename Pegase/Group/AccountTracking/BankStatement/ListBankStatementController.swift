//
//  BankStatement.swift
//  Pegase
//
//  Created by thierryH24 on 22/04/2021.
//  Copyright © 2021 thierry hentic. All rights reserved.
//

import AppKit
import PDFKit

final class ListBankStatementController: NSViewController, DragViewDelegate  {
    
    @IBOutlet weak var tableBankStatement: NSTableView!
    @IBOutlet weak var viewModeButton: NSButton?
    
    var originalColumns = [NSTableColumn]()
    
    enum BankStatementDisplayProperty: String {
        case idCol
        
        case dateDebCol
        case soldeDebCol
        
        case dateInterCol
        case soldeInterCol
        
        case dateFinCol
        case soldeFinCol
        
        case dateCBCol
        case soldeCBCol
        
        case nameCol
        case pdfCol
    }
    
    public var delegate: FilterDelegate?
    
    var entityBankStatements : [EntityBankStatement] = []
    var entityBankStatement : EntityBankStatement?
    
    var viewModel = ViewModel()
    
    var bankStatementModalWindowController : BankStatementModalWindowController!
    
    let formatterDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter
    }()
    
    var urls: [URL] = []
    var url =  URL(string: "")
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        NotificationCenter.receive( self, selector: #selector(updateChangeAccount(_:)), name: .updateAccount)
        NotificationCenter.receive( self, selector: #selector(selectionDidChange(_:)), name: .selectionDidChangeTable)
    }
    
    override func viewDidAppear()
    {
        super.viewDidAppear()
        view.window!.title = "List Bank Statement"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        tableBankStatement.delegate = self
        tableBankStatement.dataSource = self
        
        originalColumns = tableBankStatement.tableColumns
        
        let id = currentAccount?.uuid.uuidString
        self.tableBankStatement.autosaveTableColumns = false
        self.tableBankStatement.autosaveName = "saveBankStatement" + (id)!
        self.tableBankStatement.autosaveTableColumns = true
        
        tableBankStatement.doubleAction = #selector(doubleClicked)
        updateData()
    }
    
    public func updateData() {
        guard currentAccount != nil else { return }
        entityBankStatements = BankStatement.shared.getAllDatas()
        //        for entity in entityBankStatements {
        //            entity.pdfDoc = nil
        //           BankStatement.shared.remove(entity: entity)
        //        }
        tableBankStatement.reloadData()
    }
    
    @objc func updateChangeAccount(_ notification: Notification) {
        updateData()
    }
    
    @objc func selectionDidChange(_ notification: Notification) {
        
        let tableView = notification.object as? NSTableView
        guard tableView == tableBankStatement else { return }
        
        let ascending = false
        
        let selectedRow = tableBankStatement.selectedRow
        if selectedRow >= 0 {
            let quake = entityBankStatements[selectedRow]
            let reference = quake.number
            
            let p1 = NSPredicate(format: "account == %@", currentAccount!)
            let p2 = NSPredicate(format: "bankStatement == %f", reference)
            let predicate = NSCompoundPredicate(type: .and, subpredicates: [p1, p2])
            
            let fetchRequest = NSFetchRequest<EntityTransactions>(entityName: "EntityTransactions")
            fetchRequest.predicate = predicate
            let s1 = NSSortDescriptor(key: "datePointage", ascending: ascending)
            let s2 = NSSortDescriptor(key: "dateOperation", ascending: ascending)
            fetchRequest.sortDescriptors = [s1, s2]
            
            delegate?.applyFilter( fetchRequest)
            //            delegate?.applyFilterTmp(reference: reference)
        }
    }
    
    @IBAction func switchDisplayMode(_ sender: Any) {
        
        viewModel.switchDisplayMode()
        
        if viewModel.displayMode == .detail {
            
            for column in tableBankStatement.tableColumns.reversed() {
                tableBankStatement.removeTableColumn(column)
            }
            
            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "detailsColumn"))
            column.width = tableBankStatement.frame.size.width
            column.title = "Purchases Detailed View"
            tableBankStatement.addTableColumn(column)
            
            viewModeButton?.title = "Switch to Plain Display Mode"
            
        } else {
            
            tableBankStatement.removeTableColumn(tableBankStatement.tableColumns[0])
            
            for column in originalColumns {
                tableBankStatement.addTableColumn(column)
            }
            viewModeButton?.title = "Switch to Detail Display Mode"
        }
        tableBankStatement.reloadData()
    }
    
    internal func dragViewDidReceive(fileURLs: [URL])
    {
        if let firstPdfFileURL = fileURLs.first
        {
            //            print( firstPdfFileURL )
            url = firstPdfFileURL
            urls.append(firstPdfFileURL)
            tableBankStatement.reloadData()
        }
    }
}

extension ListBankStatementController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return entityBankStatements.count
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let descriptor = tableView.sortDescriptors.first else { return }
        
        let key = descriptor.key!
        sortNumber(key: key, ascending: descriptor.ascending)
        tableView.reloadData()
    }
    
    func sortNumber(key: String, ascending: Bool) {
        
        entityBankStatements.sort { (p1, p2) -> Bool in
            var id1 = 0.0
            var id2 = 0.0
            switch key {
            case "id":
                id1 = p1.number
                id2 = p2.number
                
            case "soldeDeb":
                id1 = p1.soldeDebut
                id2 = p2.soldeDebut
            case "dateDeb":
                id1 = p1.dateDebut!.timeIntervalSince1970
                id2 = p2.dateDebut!.timeIntervalSince1970
                
            case "soldeInter":
                id1 = p1.soldeInter
                id2 = p2.soldeInter
            case "dateInter":
                id1 = p1.dateInter!.timeIntervalSince1970
                id2 = p2.dateInter!.timeIntervalSince1970
                
            case "soldeFin":
                id1 = p1.soldeFin
                id2 = p2.soldeFin
            case "dateFin":
                id1 = p1.dateFin!.timeIntervalSince1970
                id2 = p2.dateFin!.timeIntervalSince1970
                
            case "soldeCB":
                id1 = p1.soldeCB
                id2 = p2.soldeCB
            case "dateCB":
                id1 = p1.dateCB!.timeIntervalSince1970
                id2 = p2.dateCB!.timeIntervalSince1970
                
            default:
                break
            }
            if ascending {
                return id1 <= id2
            } else {
                return id2 < id1
            }
        }
    }
}

extension ListBankStatementController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let entityBankStatement = entityBankStatements[row]
        
        if viewModel.displayMode == .plain {
            
            let identifier = tableColumn!.identifier
            guard let propertyEnum = BankStatementDisplayProperty(rawValue: identifier.rawValue) else { return nil }
            
            var cellView: NSTableCellView?
            
            switch propertyEnum
            {
            case .idCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "idNumCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.doubleValue = entityBankStatement.number
                
            case .dateDebCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "dateDebCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.stringValue = ""
                
                if let time = entityBankStatement.dateDebut {
                    let formattedDate = formatterDate.string(from: time)
                    cellView?.textField?.stringValue = formattedDate
                }
                
            case .soldeDebCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "soldeInitCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.stringValue = entityBankStatement.soldeDebut.asLocaleCurrency
                
            case .dateInterCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "dateInterCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.stringValue = ""
                
                if let time = entityBankStatement.dateInter {
                    let formattedDate = formatterDate.string(from: time)
                    cellView?.textField?.stringValue = formattedDate
                }
                
            case .soldeInterCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "soldeInterCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.stringValue = entityBankStatement.soldeInter.asLocaleCurrency
                
                
            case .dateFinCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "dateFinCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.stringValue = ""
                
                if let time = entityBankStatement.dateFin {
                    let formattedDate = formatterDate.string(from: time)
                    cellView?.textField?.stringValue = formattedDate
                }
                
            case .soldeFinCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "soldeFinCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.stringValue = entityBankStatement.soldeFin.asLocaleCurrency
                
            case .dateCBCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "dateCBCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.stringValue = ""
                
                if let time = entityBankStatements[row].dateCB {
                    let formattedDate = formatterDate.string(from: time)
                    cellView?.textField?.stringValue = formattedDate
                }
                
            case .soldeCBCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "soldeCBCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.stringValue =  entityBankStatement.soldeCB.asLocaleCurrency
                
            case .nameCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "nameCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.stringValue =  entityBankStatement.pdfName ?? "nil"

            case .pdfCol:
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "pdfCell")
                cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
                cellView?.textField?.stringValue = ""
                
                let list = entityBankStatements[row] as EntityBankStatement
                
                if let pdfDoc = list.pdfDoc {
                    let pdfDocument = PDFDocument(data: pdfDoc )
                    if let firstPage = pdfDocument?.page(at: 0) {
                        cellView?.imageView?.image = firstPage.thumbnail(of: NSSize(width: 256, height: 256), for: .artBox)
                    }
                }
                else {
                    cellView?.imageView?.image = nil
                }
            }
            return cellView
        } else
        {
            let view = ListBankStatementDetailview()
            
            if let time = entityBankStatement.dateDebut {
                let formattedDate = formatterDate.string(from: time)
                view.startDate?.stringValue = formattedDate
            }
            if let time = entityBankStatement.dateInter {
                let formattedDate = formatterDate.string(from: time)
                view.interDate?.stringValue = formattedDate
            }
            if let time = entityBankStatement.dateFin {
                let formattedDate = formatterDate.string(from: time)
                view.endDate?.stringValue = formattedDate
            }
            if let time = entityBankStatement.dateCB {
                let formattedDate = formatterDate.string(from: time)
                view.cbDate?.stringValue = formattedDate
            }
            view.startSolde?.doubleValue = entityBankStatement.soldeDebut
            view.interSolde?.doubleValue = entityBankStatement.soldeInter
            view.endSolde?.doubleValue = entityBankStatement.soldeFin
            view.cbAmount?.doubleValue = entityBankStatement.soldeCB
            
            view.reference?.doubleValue = entityBankStatement.number
            view.namePDF?.stringValue = entityBankStatement.pdfName ?? ""

            return view
        }
    }
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        
        if edge == .leading  {
            let leftAction = NSTableViewRowAction(style: .destructive, title: "Delete") { (action, row) in
                self.tableBankStatement.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
            }
            let rightAction = NSTableViewRowAction(style: .regular, title: "Edit")  { (action, row) in
                self.editBankStatement(row)
            }

            return [leftAction, rightAction]
        }
        
        if edge == .trailing  {
            let rightAction = NSTableViewRowAction(style: .destructive, title: "Edit")  { (action, row) in
                self.editBankStatement(row)
            }
            return [rightAction]
        }
        return []
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if viewModel.displayMode == .plain {
            return 21.0
        } else {
            return 150.0
        }
    }
    func numberFormated(value: Double) -> String {
        
        let formatterPrice: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            return formatter
        }()
        
        var price: NSNumber = 0.0
        var formatted = ""
        price = value as NSNumber
        formatted = formatterPrice.string(from: price)!
        return formatted
    }
}

extension Double {
    var asLocaleCurrency:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }
}
