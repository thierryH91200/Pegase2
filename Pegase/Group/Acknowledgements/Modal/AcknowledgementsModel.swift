//
//  AcknowledgementsModel.swift
//  AuroraEditorModules/Acknowledgements
//
//  Created by Lukas Pistrol on 01.05.22.
//

import SwiftUI

final class AcknowledgementsModel: ObservableObject {

    @Published
    private (set) var acknowledgements: [Dependency]
    
    var datas       = [Pin]()


    public init(_ dependencies: [Dependency] = []) {
        self.acknowledgements = dependencies

        if acknowledgements.isEmpty {
            fetchDependencies()
        }
    }

    public func fetchDependencies() {
        self.acknowledgements.removeAll()
        
        do {
             if let bundlePath = Bundle.main.path(forResource: "Package.resolved", ofType: nil) {
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
                let parsedJSON = try JSONDecoder().decode(RootObject.self, from: jsonData!)
                for dependency in parsedJSON.object.pins.sorted(by: { $0.identity < $1.identity })
                where dependency.identity.range(
                        of: "[pP]egase",
                        options: .regularExpression,
                        range: nil,
                        locale: nil
                    ) == nil {
                    self.acknowledgements.append(
                        Dependency(
                            identity: dependency.identity,
                            location: dependency.location,
                            version: dependency.state.version ?? ""
                        )
                    )
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func feedList(_ fileName: String) {
        
        if let jsonURL = Bundle.main.url(forResource: "persons", withExtension: "json") {
            let jsonData = try! Data(contentsOf: jsonURL)
            let jsonDecoder = JSONDecoder()
            let persons = try! jsonDecoder.decode([Pin].self, from: jsonData)
        }

        
        let url = Bundle.main.url(forResource: fileName, withExtension: "resolved")!
        let data = try! Data(contentsOf: url)
        datas = try! data.decoded()
        
        // or
        // datas = try! data.decoded() as [Donnees]

        // or
        // let plistDecoder = PropertyListDecoder()
        // datas = try! plistDecoder.decode([Donnees].self, from: data)
    }

}
