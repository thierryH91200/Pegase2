//
//  SettingVM.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2021/12/11.
//

import Foundation
import SwiftUI


enum SettingsItem:String {
    case General = "General"
    case Customize = "Customize"

    @ViewBuilder
    var page: some View {
        switch self {
        case .General:
            EmptyView() // break does not work with ViewBuilder
    
        case .Customize:
            EmptyView() // break does not work with ViewBuilder
        }
    }

}

class SettingsVM:ObservableObject {
    
    static let shared = SettingsVM()
    
    var window:NSWindow?
    
    @Published var settingItems:[SettingsItem] = [
                                                 .General,
                                                 .Customize]
    
    @Published var selection:SettingsItem? = .General
}
