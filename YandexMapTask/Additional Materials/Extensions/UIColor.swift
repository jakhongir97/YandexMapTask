//
//  UIColor.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor {
        return UIColor(named: name.rawValue) ?? .red
    }
}

