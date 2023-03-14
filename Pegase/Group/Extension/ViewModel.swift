//
//  ViewModel.swift
//  TableDemo
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Foundation

enum DisplayMode {
    case plain
    case detail
}

class ViewModel: NSObject {
    
    // MARK: - Properties
    private(set) var displayMode: DisplayMode = .plain
    
    // MARK: - Init
    override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    func switchDisplayMode() {
//        displayMode = displayMode == .plain ? .detail : .plain
        if displayMode == .plain {
            displayMode = .detail
        } else {
            displayMode = .plain
        }
    }
    
}
