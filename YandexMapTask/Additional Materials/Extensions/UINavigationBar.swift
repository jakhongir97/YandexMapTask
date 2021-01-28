//
//  UINavigationBar.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

extension UINavigationBar {
    func opacityNavBar() {
        shadowImage = UIImage()
        titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.appColor(.myBlack)]
        barTintColor = UIColor.appColor(.mySecondBackground)
        backgroundColor = .clear
        isTranslucent = false
        setBackgroundImage(UIImage(), for: .default)
        tintColor = UIColor.appColor(.myBlack)
    }
}
