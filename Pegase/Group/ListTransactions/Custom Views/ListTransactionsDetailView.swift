//
//  PaymentInfoCellView.swift
//  TableDemo
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Cocoa

class ListTransactionsDetailView: NSView, LoadableView {
    
    @IBOutlet weak var reference: NSTextField?
    
    @IBOutlet weak var startDate: NSTextField?
    @IBOutlet weak var valueDate: NSTextField?
    @IBOutlet weak var endDate: NSTextField?
    
    @IBOutlet weak var frequency: NSTextField?
    @IBOutlet weak var occurence: NSTextField?
    
    @IBOutlet weak var rubric: NSTextField?
    @IBOutlet weak var category: NSTextField?
    @IBOutlet weak var modePaiement: NSTextField?
    @IBOutlet weak var Amount: NSTextField?
    
    @IBOutlet weak var number: NSTextField?
    @IBOutlet weak var account: NSTextField?
    @IBOutlet weak var name: NSTextField?
    @IBOutlet weak var surname: NSTextField?


    // MARK: - Properties
    var mainView: NSView?
    
    // MARK: - Init
    init() {
        super.init(frame: NSRect.zero)
        
        _ = load(fromNIBNamed: "ListTransactionsDetailView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
}
