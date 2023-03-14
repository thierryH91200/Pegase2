


import AppKit

extension RubriqueViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
                
        if isHeader(item: item) == true {
            
            let entityRubric = item as! EntityRubric

            let cellView =  outlineView.makeView(withIdentifier: .RubriqueCell, owner: self) as! KSHeaderCellView3
            
            cellView.textField?.stringValue = entityRubric.name!
            cellView.textField?.textColor = entityRubric.color! as? NSColor
            cellView.total?.doubleValue = entityRubric.total

            cellView.colorWell.color = (entityRubric.color! as? NSColor)!
            cellView.colorWell.isEnabled = false
            
            cellView.oldFont = nil
            cellView.oldColor = nil

            return cellView
            
        } else {
            let entityCategory = item as! EntityCategory
            
            let cellView = outlineView.makeView(withIdentifier: .CategoryCell, owner: self) as! KSTableCellView2
            let color = entityCategory.rubric!.color! as? NSColor
            
            cellView.name?.textColor = color
            cellView.name?.stringValue = entityCategory.name!

            cellView.objectif?.textColor = color
            cellView.objectif?.doubleValue = entityCategory.objectif
            
            cellView.oldFont = nil
            cellView.oldColor = nil

            return cellView
        }
    }
    
    // indicates whether a given row should be drawn in the “group row” style.
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool
    {
        return false //isHeader(item: item)
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool
    {
        return true
    }
    
    func isHeader(item: Any) -> Bool {
        
        if item is EntityRubric
        {
            return true
        } else {
            return false
        }
    }
    
    func outlineViewItemDidExpand(_ notification: Notification) {

        let ov = notification.object as? NSOutlineView
        ov!.autosaveExpandedItems = true

        let optionKeyIsDown = optionKeyPressed()
        if optionKeyIsDown == true {
            ov!.animator().expandItem(nil, expandChildren: true)
        }
    }

    func outlineViewItemDidCollapse(_ notification: Notification) {

        let ov = notification.object as? NSOutlineView
        ov!.autosaveExpandedItems = true

        let optionKeyIsDown = optionKeyPressed()
        if optionKeyIsDown == true {
            ov!.animator().collapseItem(nil, collapseChildren:  true)
        }
    }

    func optionKeyPressed() -> Bool
    {
        let optionKey = NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.option)
        return optionKey
    }
}

