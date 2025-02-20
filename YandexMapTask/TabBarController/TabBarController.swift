//
//  TabBarController.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Attributes
    internal let addressCoordinator = AddressCoordinator(navigationController: UINavigationController())
    internal var mapCoordinator = MapCoordinator(navigationController: UINavigationController())
    internal var profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
    
    // MARK: - Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        createControllers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createControllers()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        createControllers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
    }
    
}

// MARK: - Other funcs
extension TabBarController {
    private func createControllers() {
        addressCoordinator.start()
        mapCoordinator.start()
        profileCoordinator.start()
        
        viewControllers = [addressCoordinator.navigationController, mapCoordinator.navigationController, profileCoordinator.navigationController]
    }
    
    private func appearanceSettings() {
        tabBar.tintColor = UIColor.appColor(.myBlack)
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        tabBar.barTintColor = UIColor.appColor(.mySecondBackground)
    }
}

