//
//  PurchasesDetailView.swift
//  TableDemo
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Cocoa

class ChequiersDetailView: NSView, LoadableView {
    
    // MARK: - IBOutlet Properties
    
    
    @IBOutlet weak var name: NSTextField!
    
    @IBOutlet weak var prefix: NSTextField!
    @IBOutlet weak var first: NSTextField!
    
    @IBOutlet weak var next: NSTextField!
    @IBOutlet weak var number: NSTextField!
    
    @IBOutlet weak var account: NSTextField!
    @IBOutlet weak var nameAccount: NSTextField!
    @IBOutlet weak var surnameAccount: NSTextField!
    @IBOutlet weak var numberAccount: NSTextField!

    // MARK: - Properties
    var mainView: NSView?
    
    // MARK: - Init
    init() {
        super.init(frame: NSRect.zero)
        
        _ = load(fromNIBNamed: "ChequiersDetailView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
