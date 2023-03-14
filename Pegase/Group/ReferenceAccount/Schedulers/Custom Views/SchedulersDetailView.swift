//
//  PurchasesDetailView.swift
//  TableDemo
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Cocoa

class SchedulersDetailView: NSView, LoadableView {
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var comment: NSTextField!
    
    @IBOutlet weak var startDate: NSTextField!
    @IBOutlet weak var valueDate: NSTextField!
    @IBOutlet weak var endDate: NSTextField!
    
    @IBOutlet weak var frequence: NSTextField!
    @IBOutlet weak var typeFrequence: NSTextField!
    @IBOutlet weak var occurence: NSTextField!
    
    @IBOutlet weak var rubrique: NSTextField!
    @IBOutlet weak var categorie: NSTextField!
    @IBOutlet weak var modeDePaiement: NSTextField!

    @IBOutlet weak var amount: NSTextField!

    // MARK: - Properties
    var mainView: NSView?
    
    // MARK: - Init
    init() {
        super.init(frame: NSRect.zero)
        
        _ = load(fromNIBNamed: "SchedulersDetailView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
