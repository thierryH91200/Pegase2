import AppKit

final class Scheduler : NSObject {
    
    static let shared = Scheduler()
    private var entities = [EntitySchedule]()
    
    var viewContext : NSManagedObjectContext?

    override init () {
        if let context = mainObjectContext
        {
            self.viewContext = context
        }
    }
    
    // delete Entity
    func remove(entity: EntitySchedule)
    {
        viewContext!.undoManager?.beginUndoGrouping()
        viewContext!.undoManager?.setActionName("DeleteSchedule")
        viewContext!.delete(entity)
        viewContext!.undoManager?.endUndoGrouping()
    }

    func getAllDatas() -> [EntitySchedule] {
        
        do {
            let fetchRequest = NSFetchRequest<EntitySchedule>(entityName: "EntitySchedule")
            let predicate = NSPredicate(format: "account == %@", currentAccount!)
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "libelle", ascending: true)]

            entities = try viewContext!.fetch(fetchRequest)
        } catch {
            print("Error fetching data from CoreData")
        }
        return entities
    }
    
    func createSousOperation (entitySchedule: EntitySchedule) -> EntitySousOperations{
        
        // create sous transaction
        let entitySplitTransaction = NSEntityDescription.insertNewObject(forEntityName: "EntitySousOperations", into: viewContext!) as! EntitySousOperations

        // la rubrique existe t elle ??
        var name = entitySchedule.category?.rubric?.name
        let color = entitySchedule.category?.rubric?.color
        var uuid = entitySchedule.category?.rubric?.uuid
        let entityRubric = Rubric.shared.findOrCreate(account: entitySchedule.account!, name: name!, color: color as! NSColor, uuid: uuid!)
        
        // la categorie existe t elle ??
        name = entitySchedule.category?.name
        let objectif = entitySchedule.category?.objectif
        uuid = entitySchedule.category?.uuid
        let entityCategory = Categories.shared.findOrCreate(account: entitySchedule.account!, name: name!, objectif: objectif!, uuid: uuid!)
        
        entitySplitTransaction.category         = entityCategory
        entitySplitTransaction.category?.rubric = entityRubric
        entitySplitTransaction.amount           = entitySchedule.amount
        entitySplitTransaction.libelle          = entitySchedule.libelle
        
        return entitySplitTransaction
    }
        
    func createTransaction (entitySchedule: EntitySchedule, dateValeur: Date) {

        entitySchedule.nextOccurence += 1
        
        let entityTransaction = NSEntityDescription.insertNewObject(forEntityName: "EntityTransactions", into: viewContext!) as! EntityTransactions
        
        entityTransaction.dateCree       = Date()
        entityTransaction.dateModifie    = Date()
        entityTransaction.dateOperation  = dateValeur
        entityTransaction.datePointage   = dateValeur

        entityTransaction.account        = entitySchedule.account
                
        entityTransaction.paymentMode    = entitySchedule.paymentMode
        entityTransaction.statut         = Date() >= dateValeur ? 2 : 1
        
        entityTransaction.bankStatement = 0
        entityTransaction.uuid           = UUID()

        // create sous transaction
        let entitySousOperation = createSousOperation(entitySchedule: entitySchedule)
        
        // addd sous transaction
        entityTransaction.addToSousOperations(  entitySousOperation)
        
        if entitySchedule.compteLie != nil {
            
            let entityTransactionsTransfert = NSEntityDescription.insertNewObject(forEntityName: "EntityTransactions", into: viewContext!) as! EntityTransactions

            entityTransactionsTransfert.dateCree      = entityTransaction.dateCree
            entityTransactionsTransfert.dateModifie   = entityTransaction.dateModifie
            entityTransactionsTransfert.dateOperation = entityTransaction.dateOperation
            entityTransactionsTransfert.datePointage  = entityTransaction.datePointage
            
            let compteLie = entitySchedule.compteLie!
            entityTransactionsTransfert.account        = compteLie

            entityTransactionsTransfert.statut        = entityTransaction.statut
            entityTransactionsTransfert.bankStatement = entityTransaction.bankStatement

            // le modePaiement existe t il ??
            var name = entityTransactionsTransfert.paymentMode?.name ?? "nil"
            let color = entityTransactionsTransfert.paymentMode?.color as? NSColor ?? NSColor.labelColor
            let uuid = entityTransactionsTransfert.paymentMode?.uuid ?? UUID()
            let entityModePaiement = PaymentMode.shared.findOrCreate(account: compteLie, name: name, color: color , uuid: uuid)
            entityTransactionsTransfert.paymentMode  = entityModePaiement

            
            let entitySousOperations = entityTransactionsTransfert.sousOperations
            let entitySplitTransactions = entitySousOperations!.allObjects as! [EntitySousOperations]
            let entitySplitTransaction = entitySplitTransactions.first

            let entityRubric = Rubric.shared.findOrCreate(account: compteLie, name: name, color: color, uuid: uuid)
            
            // la categorie existe t elle ?
            name = entitySchedule.category?.name ?? "nil"
            let objectif = entitySchedule.category?.objectif
            let entityCategorie = Categories.shared.findOrCreate(account: compteLie, name: name, objectif: objectif!, uuid: uuid)
            
            entitySplitTransaction?.category = entityCategorie
            entitySplitTransaction?.category?.rubric = entityRubric
            entitySplitTransaction?.amount       = -entitySchedule.amount

            entityTransactionsTransfert.addToSousOperations(entitySousOperation)
            
            entityTransactionsTransfert.uuid          = UUID()
        }
    }
}
