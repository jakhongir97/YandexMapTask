//
//  Coordinator.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}
