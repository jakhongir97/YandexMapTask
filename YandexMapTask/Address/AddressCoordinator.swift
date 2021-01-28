//
//  AddressCoordinator.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

final class AddressCoordinator: Coordinator {
    
    internal var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    internal func start() {
        let vc = AddressViewController()
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage.appImage(.address), tag: 0)
        vc.tabBarItem.setImageOnly()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
}
