//
//  ParsePackagesResolved.swift
//  AuroraEditorModules/Acknowledgements
//
//  Created by Shivesh M M on 4/4/22.
//

import Foundation

struct Dependency: Decodable {
    var identity: String
    var location: String
    var version: String
    var repositoryURL: URL {
        URL(string: location)!
    }
}

struct RootObject: Codable {
    let object: Object
}

// MARK: - Object
struct Object: Codable {
    let pins: [Pin]
}

// MARK: - Pin
struct Pin: Codable {

    let identity: String
    let kind: String
    let location: String
    let state: AcknowledgementsState
}

// MARK: - State
struct AcknowledgementsState: Codable {
//    let branch: String?
    let revision: String
    let version: String?
}


