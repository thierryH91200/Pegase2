//
//  SplitViewVC.swift
//  MyMacOSApp
//
//  Created by steve.ham on 2021/01/01.
//

import Cocoa

extension NSViewController:  NSSplitViewDelegate {
    
//    public func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
//        proposedMinimumPosition + 100
//    }
//
//    public func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
//        proposedMaximumPosition - 100
//    }
//    
    public func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        let left = splitView.subviews[0]
        let right = splitView.subviews[2]
        
        if subview == left || subview == right {
            return true
        } else {
            return false
        }
    }
}

