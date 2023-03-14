import AppKit

extension RubriqueViewController : NSMenuDelegate {
    
    func menuWillOpen( _ menu: NSMenu) {
        let selected = self.anOutlineView.selectedRow
        let item = self.anOutlineView.item(atRow: selected)
        
        let entity = item is EntityRubric

        for menuItem in menu.items
        {
            let tag = menuItem.tag
            menuItem.isHidden =  true
            if entity == true, tag == 0 {
                menuItem.isHidden =  false
            }
            if entity == false, tag == 1 {
                menuItem.isHidden =  false
            }
        }
    }
    
    @IBAction func ExpandAll(_ sender: NSButton) {
        anOutlineView.expandItem(nil, expandChildren: true)
    }
    
    @IBAction func printDoc(_ sender: NSButton) {
        anOutlineView.expandItem(nil, expandChildren: true)
    }

    // MARK: - Rubrique
    @IBAction func addRubrique(_ sender: NSButton) {
        
        let context = mainObjectContext

        self.rubriqueModalWindowController = RubriqueModalWindowController()

        self.view.window?.beginSheet(rubriqueModalWindowController.window!, completionHandler: {(_ returnCode: NSApplication.ModalResponse) -> Void in
            
            switch returnCode {
            case .OK:
                let name = self.rubriqueModalWindowController.name.stringValue
                let color = self.rubriqueModalWindowController.colorWell.color
                
                let entity = NSEntityDescription.insertNewObject(forEntityName: "EntityRubric", into: context!) as! EntityRubric

                entity.name = name
                entity.color = color
                entity.uuid = UUID()
                entity.account = currentAccount
                
                self.anOutlineView.reloadData()

            case .cancel:
                break
                
            default:
                break
            }
            self.rubriqueModalWindowController = nil
        })
    }
    
     @IBAction func editRubrique(_ sender: NSButton) {
         
         let selectRow = anOutlineView.selectedRow
         guard selectRow != -1 else { return }
         let item = anOutlineView.item(atRow: selectRow)
    
        let entityRubrique = item as! EntityRubric

        self.rubriqueModalWindowController = RubriqueModalWindowController()
        self.rubriqueModalWindowController.edition = true
        self.rubriqueModalWindowController.nameRubrique = entityRubrique.name ?? ""
        self.rubriqueModalWindowController.colorRubrique = entityRubrique.color as! NSColor
        
         self.view.window?.beginSheet(rubriqueModalWindowController.window!, completionHandler: {(_ returnCode: NSApplication.ModalResponse) -> Void in
             
             switch returnCode {
             case .OK:
                entityRubrique.name = self.rubriqueModalWindowController.name.stringValue
                entityRubrique.color = self.rubriqueModalWindowController.colorWell.color

                self.anOutlineView.reloadData()
                 
             case .cancel:
                 break
                 
             default:
                 break
             }
             self.rubriqueModalWindowController = nil
         })
     }

    @IBAction func removeRubrique(_ sender: NSButton) {
        
        let context = mainObjectContext
        
        let entityPreference = Preference.shared.getAllDatas()
        var entityOperations = [EntityTransactions]()
        let p1 = NSPredicate(format: "account == %@", currentAccount!)
        
        let selected = self.anOutlineView.selectedRow
        
        let item = self.anOutlineView.item(atRow: selected)
        let entityRubric = item as? EntityRubric
        
        if entityPreference.category?.rubric == entityRubric {
            let alert = NSAlert()
            alert.alertStyle = NSAlert.Style.critical
            alert.icon = nil
            alert.messageText = "Impossible de supprimer la rubrique par défaut. Changez la valeur par défaut dans les références du compte"
            alert.runModal()
            return
        }
        
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        alert.messageText = Localizations.Rubric.MessageText
        alert.informativeText = Localizations.Rubric.InformativeText
        alert.addButton(withTitle: Localizations.Rubric.Delete)
        alert.addButton(withTitle: Localizations.General.Cancel)
        alert.alertStyle = NSAlert.Style.informational
        
        alert.beginSheetModal(for: view.window!, completionHandler: {(_ returnCode: NSApplication.ModalResponse) -> Void in
            if returnCode == .alertSecondButtonReturn {
                return
            }
            
            let p2 = NSPredicate(format: "SUBQUERY(sousOperations, $sousOperation, $sousOperation.category.rubric == %@).@count > 0", entityRubric!)
            let predicate = NSCompoundPredicate(type: .and, subpredicates: [p1, p2])

            let fetchRequest = NSFetchRequest<EntityTransactions>(entityName: "EntityTransactions")
            fetchRequest.predicate = predicate
            
            do {
                entityOperations = try context!.fetch(fetchRequest)
            } catch {
                print("Error fetching data from CoreData !")
            }
            
            for entityOperation in entityOperations {
                let sousOperations = entityOperation.sousOperations?.allObjects  as! [EntitySousOperations]
                for sousOperation in sousOperations {
                    sousOperation.category = entityPreference.category
                    sousOperation.category?.rubric = entityPreference.category?.rubric
                }
            }
            print("This element was 🗑! : ", entityRubric!.name!)
            context!.delete(entityRubric!)
            self.updateData()
        })
    }
    
    // MARK: Categorie
    @IBAction func addCategorie(_ sender: NSButton) {
        
        let context = mainObjectContext

        let selectRow = anOutlineView.selectedRow
        guard selectRow != -1 else { return }
        let item = anOutlineView.item(atRow: selectRow)

        var entityRubric: EntityRubric
        
        if item is EntityRubric {
            entityRubric = item as! EntityRubric
        } else {
            let entityCategory = item as! EntityCategory
            entityRubric = entityCategory.rubric!
        }
        
        self.categorieModalWindowController = CategorieModalWindowController()
        let windowAdd = categorieModalWindowController.window!
        let windowApp = self.view.window
        windowApp?.beginSheet( windowAdd, completionHandler: {(_ returnCode: NSApplication.ModalResponse) -> Void in
            
            switch returnCode {
            case .OK:
                let name = self.categorieModalWindowController.name.stringValue
                let objectif = self.categorieModalWindowController.objectif.doubleValue
                
                let entityCategory = NSEntityDescription.insertNewObject(forEntityName: "EntityCategory", into: context!) as! EntityCategory

                entityCategory.name = name
                entityCategory.objectif = objectif
                entityCategory.rubric = entityRubric
                
                self.anOutlineView.reloadData()
                
            case .cancel:
                break
                
            default:
                break
            }
            self.categorieModalWindowController = nil
        })
        
    }
    
    @IBAction func editCategorie(_ sender: NSButton) {
        
        let selectRow = anOutlineView.selectedRow
        guard selectRow != -1 else { return }
        let item = anOutlineView.item(atRow: selectRow)
        
        let entityCategory = item as? EntityCategory
        
        self.categorieModalWindowController = CategorieModalWindowController()
        self.categorieModalWindowController.edition = true
        self.categorieModalWindowController.nameCategory  = entityCategory?.name ?? ""
        self.categorieModalWindowController.objectifCategory = entityCategory?.objectif ?? 0.0

        let windowAdd = categorieModalWindowController.window!
        let windowApp = self.view.window
        windowApp?.beginSheet( windowAdd, completionHandler: {(_ returnCode: NSApplication.ModalResponse) -> Void in
            
            switch returnCode {
            case .OK:
                entityCategory?.name = self.categorieModalWindowController.name.stringValue 
                entityCategory?.objectif = self.categorieModalWindowController.objectif.doubleValue

                self.anOutlineView.reloadData()
                
            case .cancel:
                break
                
            default:
                break
            }
            self.categorieModalWindowController = nil
        })
    }
    
    @IBAction func removeCategory(_ sender: NSButton) {
        
        let context = mainObjectContext

        let entityPreference = Preference.shared.getAllDatas()
        var entityOperations = [EntityTransactions]()
        let p1 = NSPredicate(format: "account == %@", currentAccount!)
        
        let selected = self.anOutlineView.selectedRow
        
        let item = self.anOutlineView.item(atRow: selected)
        
        let entityCategory = item as? EntityCategory
        
        if entityCategory != nil {
            if entityPreference.category == entityCategory {
                let alert = NSAlert()
                alert.alertStyle = NSAlert.Style.critical
                alert.icon = nil
                alert.messageText = "Impossible de supprimer la catégorie par défaut. Changez la valeur par défaut dans les références du compte"
                alert.runModal()
                return
            }
        }
        
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        alert.messageText = Localizations.Rubric.MessageText
        alert.informativeText = Localizations.Rubric.InformativeText
        alert.addButton(withTitle: Localizations.Rubric.Delete)
        alert.addButton(withTitle: Localizations.General.Cancel)
        alert.alertStyle = NSAlert.Style.informational
        
        alert.beginSheetModal(for: view.window!, completionHandler: {(_ returnCode: NSApplication.ModalResponse) -> Void in
            if returnCode == .alertSecondButtonReturn {
                return
            }
            
            let p2 = NSPredicate(format: "SUBQUERY(sousOperations, $sousOperation, $sousOperation.category == %@).@count > 0", entityCategory!)
            let predicate = NSCompoundPredicate(type: .and, subpredicates: [p1, p2])
            
            let fetchRequest = NSFetchRequest<EntityTransactions>(entityName: "EntityTransactions")
            fetchRequest.predicate = predicate
            
            do {
                entityOperations = try context!.fetch(fetchRequest)
                
            } catch {
                print("Error fetching data from CoreData !")
            }
            
            for entityOperation in entityOperations {
                let sousOperations = entityOperation.sousOperations?.allObjects  as! [EntitySousOperations]
                for sousOperation in sousOperations where sousOperation.category?.name ==  entityCategory?.name {
                    sousOperation.category = entityPreference.category
                    sousOperation.category?.rubric = entityPreference.category?.rubric
                }
            }
            print("This element was 🗑! : ", entityCategory!.name!)

            context!.delete(entityCategory!)
            self.updateData()
        })
    }
    
}

