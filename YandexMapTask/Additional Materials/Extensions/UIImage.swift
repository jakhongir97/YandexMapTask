//
//  UIImage.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

extension UIImage {
    static func appImage(_ name: AssetsImage) -> UIImage {
        return UIImage(named: name.rawValue) ?? UIImage()
    }
}
