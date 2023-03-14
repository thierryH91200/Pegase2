
import Cocoa

final class ChequiersViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var viewModeButton: NSButton?

    
//    @IBOutlet var arrayController: NSArrayController!
    @IBOutlet weak var menuLocal: NSMenu!
    
    @objc dynamic var context: NSManagedObjectContext! = mainObjectContext
    @objc dynamic var predicate =  NSPredicate(format: "account == %@", currentAccount!)
    
    var chequierModalWindowController: ChequierModalWindowController!
    
    var viewModel = ViewModel()
    var originalColumns = [NSTableColumn]()
    
    var entityCarnetCheques : [EntityCarnetCheques] = []
    var entityCarnetCheque : EntityCarnetCheques?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.receive( self, selector: #selector(updateChangeAccount(_:)), name: .updateAccount)
        
        originalColumns = tableView.tableColumns
        
        tableView.delegate = self
        tableView.dataSource = self

        updateData()
    }
    
    @objc func updateChangeAccount(_ note: Notification) {
//        updateData()
    }
    
    func updateData() {
        guard currentAccount != nil else { return }
        entityCarnetCheques = ChequeBook.shared.getAllDatas()
        tableView.reloadData()
    }
    
    @IBAction func editChequier(_ sender: Any) {
        
        let selectedRow = tableView.selectedRow
        guard selectedRow >= 0 else { return }
        
        
        let entityCheck = entityCarnetCheques[selectedRow]
        
        self.chequierModalWindowController = ChequierModalWindowController()
        self.chequierModalWindowController.entityCarnetCheques = entityCheck
        self.chequierModalWindowController.edition = true
        
        let windowAdd = chequierModalWindowController.window!
        let windowApp = self.view.window
        windowApp?.beginSheet( windowAdd, completionHandler: {(_ returnCode: NSApplication.ModalResponse) -> Void in
            
            switch returnCode {
            case .OK:
                
                entityCheck.name       = self.chequierModalWindowController.name.stringValue
                entityCheck.prefix     = self.chequierModalWindowController.prefix.stringValue
                entityCheck.numPremier = self.chequierModalWindowController.numFirst.intValue
                entityCheck.numSuivant = self.chequierModalWindowController.numNext.intValue
                entityCheck.nbCheques  = self.chequierModalWindowController.numberCheques.intValue
                
                self.tableView.reloadData()
                
            case .cancel:
                print("Cancel button tapped in Custom addAccont Sheet")
                
            default:
                break
            }
            self.chequierModalWindowController = nil
        })
        updateData()
    }

    @IBAction func addChequier(_ sender: Any) {
                
        self.chequierModalWindowController = ChequierModalWindowController()
        let windowAdd = chequierModalWindowController.window!
        let windowApp = self.view.window
        windowApp?.beginSheet( windowAdd, completionHandler: {(_ returnCode: NSApplication.ModalResponse) -> Void in
            
            switch returnCode {
            case .OK:
                
                let name          = self.chequierModalWindowController.name.stringValue
                let prefix        = self.chequierModalWindowController.prefix.stringValue
                let numFirst      = self.chequierModalWindowController.numFirst.intValue
                let numNext       = self.chequierModalWindowController.numNext.intValue
                let numberCheques = self.chequierModalWindowController.numberCheques.intValue
                
                let entityCarnetCheques        = NSEntityDescription.insertNewObject(forEntityName: "EntityCarnetCheques", into: self.context!) as! EntityCarnetCheques
                
                entityCarnetCheques.name       = name
                entityCarnetCheques.prefix     = prefix
                entityCarnetCheques.numPremier = numFirst
                entityCarnetCheques.numSuivant = numNext
                entityCarnetCheques.nbCheques  = numberCheques
                
                entityCarnetCheques.uuid = UUID()
                entityCarnetCheques.account = currentAccount
                currentAccount?.addToCarnetCheques(entityCarnetCheques)

                self.tableView.reloadData()

            case .cancel:
                break
            default:
                break
            }
            self.chequierModalWindowController = nil
            self.updateData()
        })
    }
    
    @IBAction func removeChequierAction(_ sender: Any) {
        
        let alert = NSAlert()
        alert.messageText = Localizations.Check.MessageText
        alert.informativeText = Localizations.Check.InformativeText
        alert.addButton(withTitle: Localizations.Check.Delete)
        alert.addButton(withTitle: Localizations.General.Cancel)
        alert.alertStyle = NSAlert.Style.informational
        
        alert.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                print("Document 🗑")
                self.updateData()
            }
        })
    }
    
    @IBAction func switchDisplayMode(_ sender: Any) {
        
        viewModel.switchDisplayMode()
        
        if viewModel.displayMode == .detail {
            
            for column in tableView.tableColumns.reversed() {
                tableView.removeTableColumn(column)
            }
            
            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "detailsColumn"))
            column.width = tableView.frame.size.width
            column.title = "Purchases Detailed View"
            tableView.addTableColumn(column)
            
            viewModeButton?.title = "Switch to Plain Display Mode"
            
        } else {
            
            tableView.removeTableColumn(tableView.tableColumns[0])
            
            for column in originalColumns {
                tableView.addTableColumn(column)
            }
            viewModeButton?.title = "Switch to Detail Display Mode"
        }
        tableView.reloadData()
    }

}

extension ChequiersViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return entityCarnetCheques.count
    }
}

extension ChequiersViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let entityCarnetCheque = entityCarnetCheques[row]

        if viewModel.displayMode == .plain {
            
            var cellView : CategoryCellView?
            let identifier = tableColumn!.identifier
            switch identifier {
            case .cheName:
                cellView = tableView.makeView(withIdentifier: .cheName, owner: self) as? CategoryCellView
                cellView?.textField?.stringValue = entityCarnetCheque.name ?? ""

            case .chePrefix:
                cellView = tableView.makeView(withIdentifier: .chePrefix, owner: self) as? CategoryCellView
                cellView?.textField?.stringValue = entityCarnetCheque.prefix ?? ""

            case .cheFirst:
                cellView = tableView.makeView(withIdentifier: .chePrefix, owner: self) as? CategoryCellView
                cellView?.textField?.intValue = entityCarnetCheque.numPremier

            case .cheNext:
                cellView = tableView.makeView(withIdentifier: .cheNext, owner: self) as? CategoryCellView
                cellView?.textField?.intValue = entityCarnetCheque.numSuivant

            case .cheNumber:
                cellView = tableView.makeView(withIdentifier: .cheNumber, owner: self) as? CategoryCellView
                cellView?.textField?.intValue = entityCarnetCheque.nbCheques

            case .account:
                cellView = tableView.makeView(withIdentifier: .account , owner: self) as? CategoryCellView
                cellView?.textField?.stringValue = entityCarnetCheque.account!.name!
            case .nameAccount:
                cellView = tableView.makeView(withIdentifier: .nameAccount, owner: self) as? CategoryCellView
                cellView?.textField?.stringValue = (entityCarnetCheque.account?.identity?.name)!
            case .surNameAccount:
                cellView = tableView.makeView(withIdentifier: .surNameAccount, owner: self) as? CategoryCellView
                cellView?.textField?.stringValue = (entityCarnetCheque.account?.identity?.surName)!
            case .numberAccount:
                cellView = tableView.makeView(withIdentifier: .numberAccount, owner: self) as? CategoryCellView
                cellView?.textField?.stringValue = (entityCarnetCheque.account?.initAccount?.codeAccount)!

            default:
                cellView = nil
            }
            cellView?.oldFont = nil
            cellView?.oldColor = nil

            return cellView
        }
        else {
            let view = ChequiersDetailView()

            view.name?.stringValue = entityCarnetCheque.name ?? ""
            
            view.prefix?.stringValue = entityCarnetCheque.prefix ?? ""
            view.first?.intValue = entityCarnetCheque.numPremier
            
            view.next?.intValue = entityCarnetCheque.numSuivant
            view.number?.intValue = entityCarnetCheque.nbCheques
            
            view.account?.stringValue = entityCarnetCheque.account!.name!
            view.nameAccount?.stringValue = (entityCarnetCheque.account?.identity?.name)!
            view.surnameAccount?.stringValue = (entityCarnetCheque.account?.identity?.surName)!
            view.numberAccount?.stringValue = (entityCarnetCheque.account?.initAccount?.codeAccount)!

            return view

        }
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if viewModel.displayMode == .plain {
            return 21.0
        } else {
            return 150.0
        }
    }


}
