//
//  GitHubEndpoint.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2022/5/26.
//

import Foundation

let httpsScheme = "https"

struct URLHost:RawRepresentable {
    var rawValue: String
}

extension URLHost {
    static var gitHubAPI:Self {
        URLHost(rawValue: "api.github.com")
    }
    
    static var userContent:Self {
        URLHost(rawValue: "raw.githubusercontent.com")
    }
}

enum EndPointKinds:String {
    case latestRelease = "repos/thierryH91200/Pegase/releases/latest"
    case releases = "repos/thierryH91200/Pegase/releases"
    case shortcutsJson = "thierryH91200/OnlySwitch/main/Pegase/Resource/ShortcutsMarket/ShortcutsMarket.json"
}
