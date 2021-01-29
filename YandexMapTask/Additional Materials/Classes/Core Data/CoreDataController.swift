//
//  CoreDataController.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 29/01/21.
//

import UIKit
import CoreData

final class CoreDataController: NSObject {
    
    private let persistenceManager: PersistenceManager
    
    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }
    
    // MARK: - Add
    internal func addOfflineSearch(uri: String, name: String? = nil, address: String? = nil) {
        let searches = persistenceManager.fetch(OfflineSearch.self, predicateKey: "uri", predicateValue: uri)
        
        if let search = searches.first {
            search.uri = uri
            search.name = name == nil ? search.name : name
            search.address = address == nil ? search.address : address
        } else {
            let newSearch = OfflineSearch(context: persistenceManager.context)
            newSearch.uri = uri
            newSearch.name = name
            newSearch.address = address
        }
        persistenceManager.save()
    }
    
    // MARK: - Get all
    internal func allOfflineSearches() -> [OfflineSearch] {
        let searches = persistenceManager.fetch(OfflineSearch.self)
        return searches
    }
    
    // MARK: - Get by
    internal func getOffLineSearch(uri: String) -> OfflineSearch? {
        let search = persistenceManager.fetch(OfflineSearch.self, predicateKey: "uri", predicateValue: uri)
        return search.first
    }
    
    // MARK: - Clear by
    internal func clearOfflineSearch(uri: String) {
        let searches = persistenceManager.fetch(OfflineSearch.self, predicateKey: "uri", predicateValue: uri)
        
        guard let search = searches.first else { return }
        persistenceManager.delete(search)
        persistenceManager.save()
    }
    
}
