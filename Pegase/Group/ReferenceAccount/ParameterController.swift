import Cocoa

final class ParameterController: NSViewController {

    @IBOutlet weak var tabView: NSTabView!
    
    var chequiersViewController: ChequiersViewController!
    var modeOfPaymentViewController: ModeOfPaymentViewController!
    var rubriqueViewController: RubriqueViewController!
    var preferenceTransactionViewController: PreferenceOperationViewController!
    
    /* Discussion
     Removing the observer stops it from receiving notifications.
     If you used addObserver(forName:object:queue:using:) to create your observer, you should call this method or removeObserver(_:) before the system deallocates any object that addObserver(forName:object:queue:using:) specifies.
     If your app targets iOS 9.0 and later or macOS 10.11 and later, and you used addObserver(_:selector:name:object:) to create your observer, you do not need to unregister the observer. If you forget or are unable to remove the observer, the system cleans up the next time it would have posted to it.
     When unregistering an observer, use the most specific detail possible. For example, if you used a name and object to register the observer, use removeObserver(_:name:object:) with the name and object.*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chequiersViewController = ChequiersViewController()
        modeOfPaymentViewController = ModeOfPaymentViewController()
        rubriqueViewController = RubriqueViewController()
        preferenceTransactionViewController = PreferenceOperationViewController()

        let chequiersItem = NSTabViewItem(viewController: chequiersViewController)
        chequiersItem.label = Localizations.PaymentMethod.Check
        
        let modeItem = NSTabViewItem(viewController: modeOfPaymentViewController)
        modeItem.label = Localizations.General.Mode_Payment
        
        let rubricItem = NSTabViewItem(viewController: rubriqueViewController)
        rubricItem.label = Localizations.General.Rubric
        
        let transactionItem = NSTabViewItem(viewController: preferenceTransactionViewController)
        transactionItem.label = Localizations.General.Transaction

        let items = tabView.tabViewItems
        for item in items {
            tabView.removeTabViewItem(item)
        }
        tabView.addTabViewItem(rubricItem)
        tabView.addTabViewItem(modeItem)
        tabView.addTabViewItem(transactionItem)
        tabView.addTabViewItem(chequiersItem)
        tabView.selectTabViewItem(at: 0)
    }
    
}
