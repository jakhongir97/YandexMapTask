//
//  UITabBarItem.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

extension UITabBarItem {
   func setImageOnly(){
       imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
       setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.clear], for: .selected)
       setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.clear], for: .normal)
   }
}
