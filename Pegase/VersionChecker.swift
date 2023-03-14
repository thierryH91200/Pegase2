//
//  VersionChecker.swift
//  Pegase
//
//  Created by thierry hentic on 11/02/2023.
//

import AppKit


public protocol VersionCheckerDelegate
{
    func versionCheckerDidNotFindNewVersion()
    func versionCheckerDidFindNewVersion(_ latestVersion: String, with: URL )
}


final class VersionChecker: NSObject, URLSessionDelegate {

    static let shared = VersionChecker()
    let configuration : URLSessionConfiguration = .default
    var session : URLSession?
    var delegate: VersionCheckerDelegate?
    
    override init () {
        super.init()
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }
    
    @objc func lastUpdateCheckDate() -> Date? {
        var date = UserDefaults.standard.object(forKey: "lastUpdateCheckDate") as? Date
        if date == nil {
            date = Date()
            UserDefaults.standard.set(date, forKey: "lastUpdateCheckDate")
        }
        return date
    }
    
    func checkForUpdates() {
        let url = URL(string: "https://github.com/thierryH91200/pegase/releases/latest")
        var requestHeader = URLRequest.init(url: url!)
        requestHeader.httpMethod = "GET"

//            session!.dataTask(with: url!).resume()
        session?.dataTask(with: requestHeader, completionHandler: { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if let l = response.value(forHTTPHeaderField: "Location") {
                    print("location", l)
                }
                print(response)
            }
            print("data is here")
//            print(response?.url)
        }).resume()

        
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping @Sendable (URLRequest?) -> Void
    ) {
        
        print("stop redirect")

        task.cancel()
        UserDefaults.standard.set(Date(), forKey: "lastUpdateCheckDate")
    
        var currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        currentVersion = "v\(currentVersion ?? "")"
        let latestVersion = request.url?.lastPathComponent
    
        switch latestVersion?.compare(currentVersion ?? "") {
        case .orderedSame, .orderedAscending:
            delegate?.versionCheckerDidNotFindNewVersion()
        case .orderedDescending:
            delegate?.versionCheckerDidFindNewVersion(latestVersion!, with: request.url!)
        case .none:
            break
        }
    }



}
