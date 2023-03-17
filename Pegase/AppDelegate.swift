//
//  AppDelegate.swift
//  Pegase
//
//  Created by thierryH24 on 19/04/2022.
//


// https://stackoverflow.com/questions/67185817/package-resolved-file-is-corrupted-or-malformed

import Cocoa

import SwiftUI

import NotificationCenter
import UserNotifications
import SwiftyTranslate

typealias TFDatePicker = NSDatePicker

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var splashScreenWindowController: SplashScreenWindowController! = nil
    var checkUpdatePresenter = GitHubPresenter.shared

    
    private var isAutomaticUpdateCheck = false
    
    @IBOutlet var checkForUpdatesMenuItem: NSMenuItem!

    let defaults = UserDefaults.standard
    private let userNotificationCenterDelegate = UserNotificationCenterDelegate()
    typealias TFDate = NSDatePicker
    
//    private var keyWindowController: MainWindowController? {
//        return NSApp.keyWindow?.windowController as? MainWindowController
//    }
    
    override init() {
        // Hacky way to get in before NSDocumentController instantiates its shared instance.
        // This way we can subclass NSDocumentController and use our class as the shared instance
        _ = DocumentController.init()
        
//        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
//        super.init()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        Defaults.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
        
//        updateController = UpdateController(appDelegate: self)
        
        checkUpdate()
        
        splashScreenWindowController = SplashScreenWindowController()
        splashScreenWindowController.showWindow(self)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, shouldPresent notification: UNNotification) -> Bool {
        return true
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        
        SwiftyTranslate.translate(text: "Hello World", from: "en", to: "fr") { result in
            switch result {
            case .success(let translation):
                print("Translated: \(translation.translated)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        let kUserDefaultsKeyVisibleColumns = "kUserDefaultsKeyVisibleColumns"
        
        // Register user defaults. Use a plist in real life.
        var dict = [String : Bool]()
        dict["datePointage"]    = false
        dict["dateTransaction"] = false
        dict["comment"]         = false
        dict["rubric"]          = false
        dict["category"]        = false
        dict["mode"]            = false
        dict["bankStatement"]   = false
        dict["statut"]          = false
        dict["checkNumber"]     = false
        
        dict["amount"]          = false
        dict["depense"]         = true
        dict["recette"]         = true
        dict["solde"]           = false
        dict["liee"]            = false
        var defaults            = [String :Any]()
        defaults[kUserDefaultsKeyVisibleColumns] = dict as Any
        UserDefaults.standard.register(defaults: defaults)
        UserDefaults.standard.set(defaults, forKey: kUserDefaultsKeyVisibleColumns)
        
        // for verify
        //   let dict1 = UserDefaults.standard.dictionary(forKey: kUserDefaultsKeyVisibleColumns)
        
        // Create the shared document controller.
        _ = TulsiDocumentController()
    }
    
    // applicationShouldOpenUntitledFile
    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        splashScreenWindowController = SplashScreenWindowController()
        splashScreenWindowController.showWindow(self)
        return false
    }
    
    func applicationShouldTerminateAfterLastWindowClosed (_ sender: NSApplication) -> Bool {
        return true
    }
    
    // Reopen mainWindow, when the user clicks on the dock icon.
    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag == true {
            return false
        }
        splashScreenWindowController = SplashScreenWindowController()
        //            _ = self.splashScreenWindowController
        //            if let splashScreenWindowController = self.splashScreenWindowController {
        splashScreenWindowController.showWindow(self)
        //    }
        return false
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Document")
        
        /*add necessary support for migration*/
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions =  [description]
        /*add necessary support for migration*/
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    @IBAction func saveAction(_ sender: Any?) {
        
        let context = persistentContainer.viewContext
        
        context.perform {
            
            if !(context.commitEditing()) {
                NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
            }
            if context.hasChanges == true {
                do {
                    try context.save()
                    print("save Action")
                } catch {
                    // Customize this code block to include application-specific recovery steps.
                    let nserror = error as NSError
                    NSApplication.shared.presentError(nserror)
                }
                context.reset()
            }
        }
    }
    
    
    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }
    
    // Returns a value that indicates if the app should terminate.
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            
            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            alert.showsSuppressionButton = true
            
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }
    
    func sendUpdateNotification(title: String, body: String, success: Bool, url: URL?) {
        
        let notificationCenter: UNUserNotificationCenter = .current()
        notificationCenter.getNotificationSettings { settings in
            
            guard [.authorized, .provisional].contains(settings.authorizationStatus) else {
                return
            }
            
            let identifier: String = UUID().uuidString
            let content: UNMutableNotificationContent = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            content.categoryIdentifier = success ? UNNotificationCategory.Identifier.success : UNNotificationCategory.Identifier.failure
            
            if success,
               let url: URL = url {
                content.userInfo = ["URL": url.path]
            }
            
            let trigger: UNTimeIntervalNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request: UNNotificationRequest = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                
                if let error: Error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func openAbout(_ sender: Any) {
        if AppDelegate.tryFocusWindow(of: AboutView.self) { return }
        
        AboutView().showWindow(width: 530, height: 220)
    }
    
    /// Tries to focus a window with specified view content type.
    /// - Parameter type: The type of viewContent which hosted in a window to be focused.
    /// - Returns: `true` if window exist and focused, oterwise - `false`
    static func tryFocusWindow<T: View>(of type: T.Type) -> Bool {
        guard let window = NSApp.windows.filter({ ($0.contentView as? NSHostingView<T>) != nil }).first
        else { return false }
        
        window.makeKeyAndOrderFront(self)
        return true
    }
    
    func checkUpdate() {
        checkUpdatePresenter.checkUpdate { result in
            switch result {
            case .success:
                let newestVersion = self.checkUpdatePresenter.latestVersion
                UserDefaults.standard.set(newestVersion, forKey: UserDefaults.Key.newestVersion)
                UserDefaults.standard.synchronize()
                if !self.checkUpdatePresenter.isTheNewestVersion {
                    OpenWindows.Update(self.checkUpdatePresenter).open()
                }
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func checkForUpdates(_ sender: Any?) {
        isAutomaticUpdateCheck = false
        checkUpdate()
    }
}

extension NSApplication {
    var isCharts: Bool {
        let dictionnary = ProcessInfo.processInfo.environment
        let chart = dictionnary["withCharts" ]                      // edit scheme/ environnement variables
        let result = chart == "1" ? true : false
        return result
    }
}


