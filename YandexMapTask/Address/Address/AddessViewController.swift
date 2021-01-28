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
    internal let viewModel = AddressViewModel()
    
    // MARK: - Data Providers

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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - Networking
extension AddressViewController : AddressViewModelProtocol {
    func didFinishFetch(data: Data) {
        
    }
}

// MARK: - Other funcs
extension AddressViewController {
    private func appearanceSettings() {
        navigationItem.title = "Мои адреса"
        navigationController?.navigationBar.opacityNavBar()
        viewModel.delegate = self
    }
}


