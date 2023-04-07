//
//  WeeklySummaryController.swift
//  Pegase
//
//  Created by thierry hentic on 18/03/2023.
//

import Cocoa
import SwiftDate


class WeeklySummaryController: NSViewController {
    
    @IBOutlet weak var tablWeeklySummary: NSTableView!
    
    enum ViewSummaryDisplayProperty: String {
        case idNum
        case dateDebCol
        case soldeCol
        
    }
    
    var listTransactions = [EntityTransactions]()
    
    struct WeeklySummary {
        var numWeek : Int
        var numYear: Int
        var num: Int
        var listTransactions : EntityTransactions?
    }

    var weeklySummarys = [WeeklySummary]()
    var weeklySummary = WeeklySummary(numWeek: 0, numYear: 0, num: 0, listTransactions: nil)
    var groupByNum = [Int: [WeeklySummary]]()
    var groupByNum1 = [Int: [WeeklySummary]]()

    override func viewWillAppear() {
        super.viewWillAppear()
        
        NotificationCenter.receive( self, selector: #selector(updateChangeAccount(_:)), name: .updateAccount)
        NotificationCenter.receive( self, selector: #selector(selectionDidChange(_:)), name: .selectionDidChangeTable)
    }

    override func viewDidAppear()
    {
        super.viewDidAppear()
//        view.window!.title = "Weekly Summary"
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        tablWeeklySummary.delegate = self
        tablWeeklySummary.dataSource = self
        
        let notif = Notification(name: .updateAccount)
        updateChangeAccount(notif)
    }
    
    @objc func updateChangeAccount(_ notification: Notification) {
        
//        var name = ""
//        name = "save" + (currentAccount?.uuid.uuidString)!

        self.getAllData()
//        self.reloadData()
        
//        outlineListView.deselectAll(nil)
//        self.resetChange()
    }

    @objc func selectionDidChange(_ notification: Notification) {
        
    }
    
    public func updateData() {
        guard currentAccount != nil else { return }
        tablWeeklySummary.reloadData()
    }
    
    func getAllData() {
        
        listTransactions = ListTransactions.shared.getAllDatas(ascending: false)

        self.balanceCalculation()
        self.weeklySummarys = self.weeklySummarys.sorted(by: { $0.num < $1.num })
        self.transformData()
    }
    
    func balanceCalculation()
    {
        var date = Date()
        let calendar = Calendar(identifier: .gregorian)
        for listTransaction in listTransactions {
            date = listTransaction.dateOperation!
            let numWeek = calendar.component(.weekOfYear, from: date)
            let numYear = calendar.component(.yearForWeekOfYear, from: date)
            weeklySummary.numYear = numYear
            weeklySummary.numWeek = numWeek
            weeklySummary.num = numYear * 100 + numWeek            

            weeklySummary.listTransactions = listTransaction
            weeklySummarys.append(weeklySummary)
        }
        

        
    }
    
    private func transformData()
    {
        groupByNum = Dictionary(grouping: weeklySummarys) { (device) -> Int in
           return device.num
       }
        
//       let groupByNum1 = self.groupByNum.sorted(by: { $0.key < $1.key })
       
        let allKeys = Set<Int>(groupByNum.map { $0.key })
        let strAllKeys = allKeys.sorted()
        for key in strAllKeys {
            let value = groupByNum[key]
//            print(value?.count ?? 1)
        }
//        print(strAllKeys)

        
    }

}

extension WeeklySummaryController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 5
    }
}

extension WeeklySummaryController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let identifier = tableColumn!.identifier
        guard let propertyEnum = ViewSummaryDisplayProperty(rawValue: identifier.rawValue) else { return nil }
        
        var cellView: NSTableCellView?
        
        switch propertyEnum
        {
        case .idNum:
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "idNumCell")
            cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
            cellView?.textField?.stringValue = "idNum"
            return cellView

        case .dateDebCol:
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "dateCell")
            cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
            cellView?.textField?.stringValue = "dateCell"
            return cellView

        case .soldeCol:
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "soldeCell")
            cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
            cellView?.textField?.stringValue = "soldeCell"
            return cellView

        }
    }
}
