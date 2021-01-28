//
//  ProfileViewController.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

class ProfileViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    // MARK: - Root View
    typealias RootView = ProfileView
    
    // MARK: - Services
    internal var coordinator: ProfileCoordinator?
    
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

// MARK: - Other funcs
extension ProfileViewController {
    private func appearanceSettings() {
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.opacityNavBar()
    }
}
