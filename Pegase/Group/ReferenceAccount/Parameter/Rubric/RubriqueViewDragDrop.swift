import AppKit

extension RubriqueViewController {
    
    func outlineView(_ outlineView: NSOutlineView,
                     draggingSession session: NSDraggingSession,
                     endedAt screenPoint: NSPoint,
                     operation: NSDragOperation) {
        
        self.draggedNode = nil
        //        anTreeController.rearrangeObjects()
        print("Drag session ended")
    }
    
    func outlineView(_ outlineView: NSOutlineView,
                     draggingSession session: NSDraggingSession,
                     willBeginAt screenPoint: NSPoint,
                     forItems draggedItems: [Any]) {
        
        draggedNode = draggedItems[0] as AnyObject?
        session.draggingPasteboard.setData(Data(), forType: NSPasteboard.PasteboardType( "DragType"))
        print("Drag session begin")
        
    }
    
    func outlineView(_ outlineView: NSOutlineView,
                     writeItems items: [Any],
                     to pasteboard: NSPasteboard) -> Bool {
        pasteboard.declareTypes(dragType, owner: self)
        draggedNode = items[0]
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView,
                     acceptDrop info: NSDraggingInfo,
                     item: Any?,
                     childIndex index: Int) -> Bool {
        
        let treeNode = item as? NSTreeNode
        var srcManagedObject = treeNode?.representedObject as? NSManagedObject
        
        var result = srcManagedObject is EntityRubric
        if result == false {
            srcManagedObject = srcManagedObject?.value(forKey: "rubric") as? NSManagedObject
            result = srcManagedObject is EntityRubric
        }
        
        let draggedNode1 = draggedNode as? NSTreeNode
        let dstManagedObject = draggedNode1?.representedObject as! NSManagedObject
        result = dstManagedObject is EntityCategory
        
        if result == false {
            return false
        }
        
        
        dstManagedObject.setValue(srcManagedObject, forKey: "rubric")
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView,
                     validateDrop info: NSDraggingInfo,
                     proposedItem item: Any?,
                     proposedChildIndex index: Int) -> NSDragOperation {
        
        // drags to the root are always acceptable
        let treeNode = item as? NSTreeNode
        if treeNode?.representedObject == nil {
            return .move
        }
        
        // Verify that we are not dragging a parent to one of it's ancestors
        // causes a parent loop where a group of nodes point to each other
        // and disappear from the control
        let draggedNode1 = draggedNode as? NSTreeNode
        let dragged = draggedNode1?.representedObject as! NSManagedObject
        
        let managedObject = treeNode?.representedObject as! NSManagedObject
        if managedObject is EntityRubric {
            return .move
        }
        if category(dragged, isSubCategoryOf: managedObject) == true {
            return .move
        }
        return .move
    }
    
    func category(_ cat: NSManagedObject, isSubCategoryOf possibleSub: NSManagedObject) -> Bool {

        guard cat != possibleSub else { return true }
        
        let possSubParent = possibleSub.value(forKey: "rubric") as? NSManagedObject
        let result = possSubParent is EntityRubric
        return result
    }
    
    func item(_ cat: NSManagedObject?, isSubItemOf possibleSub: NSManagedObject?) -> Bool {
        if cat == possibleSub {
            return true
        }
        
        var possibleSubParent = possibleSub?.value(forKey: "parent") as? NSManagedObject
        if possibleSubParent == nil {
            return false
        }
        
        while possibleSubParent != nil {
            if possibleSubParent == cat {
                return true
            }
        
            possibleSubParent = possibleSubParent?.value(forKey: "parent") as? NSManagedObject
        }
        return false
    }
}


//- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pasteboard {
//    [pasteboard declareTypes:_dragType owner:self];
//    _draggedNode = [items objectAtIndex:0];
//    return YES;
//}


// Here's what we do when the item is actually dropped...
//- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id&lt;NSDraggingInfo&gt;)info item:(id)item childIndex:(NSInteger)index {
//    VirtualHost *parent = [item representedObject];
//    VirtualHost *vh = [_draggedNode representedObject];
//    [vh setValue:parent forKey:@"parent"];
//
//    // If we dropped a new top-level item...
//    if(parent == NULL) {
//        // Get an arrary of all the other top-level items...
//        // (We could have just done a Core Data fetch, but this works, too.)
//        NSMutableArray *rootLevelItems = [NSMutableArray array];
//        for(NSUInteger i = 0; i &lt; [_outlineView numberOfRows]; i++) {
//            VirtualHost *item = [[_outlineView itemAtRow:i] representedObject];
//            if(item.parent == NULL) {
//                [rootLevelItems addObject:item];
//            }
//        }
//
//        // Order them appropriately...
//        for(NSUInteger i = 0; i &lt; [rootLevelItems count]; i++) {
//            VirtualHost *item = [rootLevelItems objectAtIndex:i];
//            item.sortOrderValue = (i + 1) * 2;
//        }
//        vh.sortOrderValue = (index + 1) * 2 - 1;
//    } else { // We dropped within another parent item...
//        // Get a sorted array of the other children...
//        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES];
//        NSArray *children = [parent.children sortedArrayUsingDescriptors:@[ sorter ]];
//
//        // Order them appropriately...
//        for(NSUInteger i = 0; i &lt; [children count]; i++) {
//            VirtualHost *item = [children objectAtIndex:i];
//            item.sortOrderValue = (i + 1) * 2;
//        }
//        vh.sortOrderValue = (index + 1) * 2 - 1;
//    }
//
//    // Tell the tree controller to resort the items based on the order we just put them in
//    [_treeController rearrangeObjects];
//
//    return YES;
//}
//
//
//
//// Decide which type of drag operations are allowed...
//- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id&lt;NSDraggingInfo&gt;)info proposedItem:(id)item proposedChildIndex:(NSInteger)index {
//    // Drags to root are always ok...
//    if([item representedObject] == NULL) {
//        return NSDragOperationGeneric;
//    }
//
//    // Don't allow drags to non-groups...
//    VirtualHost *vh = [item representedObject];
//    if(!vh.isFolderValue) {
//        return NSDragOperationNone;
//    }
//
//    // Don't allow dragging groups into other groups.
//    // You can remove this if you're ok with nested groups.
//    VirtualHost *dragged = [_draggedNode representedObject];
//    if(dragged.isFolderValue &amp;&amp; vh.isFolderValue) {
//        return NSDragOperationNone;
//    }
//
//    // Verify that we are not dragging a parent to one of its ancestors
//    NSManagedObject *newP = [item representedObject];
//    if([self item:dragged isSubItemOf:newP]) {
//        return NSDragOperationNone;
//    }
//
//    return NSDragOperationGeneric;
//}
