//
//  AccountGroupViewController.swift
//  Pegase
//
//  Created by thierryH24 on 19/09/2021.
//

import AppKit

extension RubriqueViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {

        var count = 0
        if item == nil {
            //at root
            count = entityRubrics.count
        } else {
            count =  (item as? EntityRubric)?.category?.count ?? 0
        }
        return count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if item == nil {
            
            return entityRubrics[index]
        } else {
            
            let source = item as! EntityRubric
            let children = source.category?.allObjects as! [EntityCategory]
            let child = children[index]
            return child
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if item is EntityRubric {
            let source = item as? EntityRubric
            let category = source?.category?.allObjects as? [EntityCategory]
            if category!.count > 0 {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, byItem item: Any?) {
        print("set object value called")
    }
    
}
