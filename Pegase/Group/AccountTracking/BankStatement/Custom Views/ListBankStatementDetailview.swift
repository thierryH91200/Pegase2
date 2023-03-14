//
//  PaymentInfoCellView.swift
//  TableDemo
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Cocoa

class ListBankStatementDetailview: NSView, LoadableView {
    
    @IBOutlet weak var reference: NSTextField?
    
    @IBOutlet weak var startDate: NSTextField?
    @IBOutlet weak var interDate: NSTextField?
    @IBOutlet weak var endDate: NSTextField?
    @IBOutlet weak var cbDate: NSTextField?

    @IBOutlet weak var startSolde: NSTextField?
    @IBOutlet weak var interSolde: NSTextField?
    @IBOutlet weak var endSolde: NSTextField?
    @IBOutlet weak var cbAmount: NSTextField?
    
    @IBOutlet weak var namePDF: NSTextField?

    // MARK: - Properties
    var mainView: NSView?
    
    // MARK: - Init
    init() {
        super.init(frame: NSRect.zero)
        
        _ = load(fromNIBNamed: "ListBankStatementDetailview")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
}
