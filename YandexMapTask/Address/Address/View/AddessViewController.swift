//
//  ViewController.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

class AddressViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    // MARK: - Root View
    typealias RootView = AddressView
    
    // MARK: - Services
    internal var coordinator: AddressCoordinator?
    private let coreDataController = CoreDataController(persistenceManager: .shared)
    
    // MARK: - Data Providers
    private var addressDataProvider: AddressDataProvider?

    // MARK: - Attributes
    override var prefersStatusBarHidden: Bool { return false }
    
    // MARK: - Actions
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        updateData()
    }
}

// MARK: - Other funcs
extension AddressViewController {
    private func appearanceSettings() {
        navigationItem.title = "Мои адреса"
        navigationController?.navigationBar.opacityNavBar()
        setupDataProvider()
    }
    
    private func setupDataProvider() {
        let addressDataProvider = AddressDataProvider(viewController: self)
        addressDataProvider.collectionView = view().collectionView
        self.addressDataProvider = addressDataProvider
    }
    
    func updateData() {
        let offlineSearches = coreDataController.allOfflineSearches()
        let items = offlineSearches.map { Search(title: $0.name, address: $0.address, distance: "", uri: $0.uri) }
        addressDataProvider?.items = items
    }
    
    func removeData(uri: String) {
        coreDataController.clearOfflineSearch(uri: uri)
        updateData()
    }
    
}


