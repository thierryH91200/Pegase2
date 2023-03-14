import AppKit

final class PersonViewController: NSViewController, Preferenceable {
    
    let toolbarItemTitle = "List"
    let toolbarItemIcon = NSImage(named: NSImage.listViewTemplateName)!
    
    @IBOutlet var reverseSignAmountCheckBbox: NSButton!
    @IBOutlet weak var autoCompleteReleve: NSButton!
    
    let defaults = UserDefaults.standard

    override var nibName: NSNib.Name? {
        return  "PersonViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let autoComplete = defaults.string(forKey: "autoComplete")
        if autoComplete == nil {
            autoCompleteReleve.state = .off
        } else {
            autoCompleteReleve.state = autoComplete == "true" ? .on : .off
        }
        let inverse = defaults.string(forKey: "reverseSign")
        if inverse == nil {
            reverseSignAmountCheckBbox.state = .off
        } else {
            reverseSignAmountCheckBbox.state = autoComplete == "true" ? .on : .off
        }
    }
    
    @IBAction func actionAutoComplete(_ sender: NSButton) {
        let new = sender.state == .on ? "true" : "false"
         defaults.set(new, forKey: "autoComplete")
    }
    
    @IBAction func actionInverseSigne(_ sender: NSButton) {
        let new = sender.state == .on ? "true" : "false"
         defaults.set(new, forKey: "reverseSign")
    }
}
