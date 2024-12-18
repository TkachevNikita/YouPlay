import Foundation
import CoreData

protocol DataManagerProtocol {
    var appDelegate: AppDelegate { get }
    func resetStorage() throws
    init(appDelegate: AppDelegate)
}

class DataManager: DataManagerProtocol {
    
    var appDelegate: AppDelegate
    
    final func resetStorage() throws {
        let storeContainer = appDelegate.persistentContainer.persistentStoreCoordinator
        
        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            } catch {
                throw error
            }
        }
        
        appDelegate.persistentContainer = NSPersistentContainer(
            name: "YouOn"
        )
        
        appDelegate.persistentContainer.loadPersistentStores {
            (store, error) in
        }
        
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.defaultAllPlaylist)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.isFirstLaunch)
    }
    
    required init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
}
