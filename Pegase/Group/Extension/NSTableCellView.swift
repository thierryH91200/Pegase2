/**
 @file      ExtensionTableView.swift
 @author    thierryH24
 @date      10/01/2018
 
 Copyright 2018 thierryH24
 
 */

import AppKit


class KSHeaderCellView3: CategoryCellView {
    
    @IBOutlet weak var colorWell: NSColorWell!
    @IBOutlet weak var total: NSTextField!
}

class KSTableCellView2: CategoryCellView {
    
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var objectif: NSTextField!
}

class KSHeaderCellView4: NSTableCellView {
    
    @IBOutlet weak var colorWell: NSColorWell!
}

    // MARK: - NSTableCellView
class CategoryCellView: NSTableCellView {
    
    var oldColor : NSColor? = nil
    var oldFont  : NSFont? = nil
    
    override var backgroundStyle: NSView.BackgroundStyle {
        willSet{
            switch newValue {
            case .emphasized :
                textField?.textColor = .labelColor
            case .normal, .raised, .lowered:
                if oldColor == nil {
                    oldColor = textField?.textColor
                    oldFont = textField?.font
                }
                textField?.textColor = oldColor
                textField?.font = oldFont
                
            @unknown default:
                break
            }
            super.backgroundStyle = newValue
        }
    }
}
