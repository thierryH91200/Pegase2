//
//  RubriqueViewController.swift
//  Pegase
//
//  Created by thierryH24 on 19/04/2022.
//

import Cocoa

final class RubriqueViewController: NSViewController {
    
    public var delegate: FilterDelegate?

    @IBOutlet weak var anOutlineView: NSOutlineView!
    @IBOutlet weak var menuLocal: NSMenu!
    
    var dragType = [NSPasteboard.PasteboardType]()
    var draggedNode: Any?
        
    var entityRubrics = [EntityRubric]()

    var selectIndex = [1]
    
    var rubriqueModalWindowController: RubriqueModalWindowController!
    var categorieModalWindowController: CategorieModalWindowController!
    
        // -------------------------------------------------------------------------------
        //    viewWillAppear
        // -------------------------------------------------------------------------------
    override func viewWillAppear() {
        super.viewWillAppear()
        
            // listen for selection changes from the NSOutlineView inside MainWindowController
            // note: we start observing after our outline view is populated so we don't receive unnecessary notifications at startup
//        NotificationCenter.receive(
//            self,
//            selector: #selector(selectionDidChange(_:)),
//            name: .selectionDidChangeOutLine)
        
        NotificationCenter.receive(
            self,
            selector: #selector(updateChangeCompte(_:)),
            name: .updateAccount)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        view.window!.title = Localizations.General.Rubric
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        
        anOutlineView.allowsEmptySelection = false
        let descriptorName = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        anOutlineView.tableColumns[0].sortDescriptorPrototype = descriptorName

        dragType = [NSPasteboard.PasteboardType( "DragType")]
        anOutlineView.registerForDraggedTypes(dragType)
        
        anOutlineView.doubleAction = #selector(doubleClicked)
        
    }
    
    @objc func updateChangeCompte(_ note: Notification) {
        updateData()
    }

    func updateData() {
        guard currentAccount != nil else { return }
                
        entityRubrics = Rubric.shared.getAllDatas()
        anOutlineView.reloadData()
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.anOutlineView.expandItem(nil, expandChildren: true)
            DispatchQueue.main.async(execute: {() -> Void in
                self.perform(#selector(self.ExpandAll), with: nil, afterDelay: 0.0)
            })
        })
    }
    
    /// Called when the a row in the sidebar is double clicked
    @objc private func doubleClicked(_ sender: Any?) {
        let clickedRow = anOutlineView.item(atRow: anOutlineView.clickedRow)
        
        if anOutlineView.isItemExpanded(clickedRow) {
            anOutlineView.collapseItem(clickedRow)
        } else {
            anOutlineView.expandItem(clickedRow)
        }
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        var p2 = NSPredicate()
        
        let sideBar = notification.object as? NSOutlineView
        guard sideBar == anOutlineView else { return }

        let selected = self.anOutlineView.selectedRow
        guard selected != -1 else { return }
        let rowView = anOutlineView.rowView(atRow: selected, makeIfNecessary: false)
        rowView?.isEmphasized = true

        let item = self.anOutlineView.item(atRow: selected)
        var name = ""

        if item is EntityRubric {
            
            name = (item as? EntityRubric)!.name!
            p2 = NSPredicate(format: "SUBQUERY(sousOperations, $sousOperation, $sousOperation.category.rubric.name == %@).@count > 0", name)

        } else {
            
            name = (item as? EntityCategory)!.name!
            p2 = NSPredicate(format: "SUBQUERY(sousOperations, $sousOperation, $sousOperation.category.name == %@).@count > 0", name)
        }

        let p1 = NSPredicate(format: "account == %@", currentAccount!)
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [p1, p2])

        let fetchRequest = NSFetchRequest<EntityTransactions>(entityName: "EntityTransactions")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateOperation", ascending: false)]

        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate?.applyFilter( fetchRequest )
        })
    }

}

