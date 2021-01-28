//
//  ViewSpecificController.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

protocol ViewSpecificController {
    associatedtype RootView: UIView
}

extension ViewSpecificController where Self: UIViewController {
    func view() -> RootView {
        return self.view as! RootView
    }
}
