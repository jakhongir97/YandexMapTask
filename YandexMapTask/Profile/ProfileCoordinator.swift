//
//  ProfileCoordinator.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    
    internal var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    internal func start() {
        let vc = ProfileViewController()
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage.appImage(.profile), tag: 2)
        vc.tabBarItem.setImageOnly()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
}
