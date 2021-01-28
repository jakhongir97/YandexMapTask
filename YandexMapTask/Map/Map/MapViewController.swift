//
//  MapViewController.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

class MapViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    // MARK: - Root View
    typealias RootView = MapView
    
    // MARK: - Services
    internal var coordinator: MapCoordinator?
    internal let viewModel = MapViewModel()
    
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - Networking
extension MapViewController : MapViewModelProtocol {
    func didFinishFetch(data: Data) {
        
    }
}

// MARK: - Other funcs
extension MapViewController {
    private func appearanceSettings() {
        viewModel.delegate = self
    }
}
