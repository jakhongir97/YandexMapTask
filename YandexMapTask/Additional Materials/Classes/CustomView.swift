//
//  CustomView.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

class CustomView: UIView {

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBackgroundColor()
    }
    
    // MARK: - UI Setup
    func setupBackgroundColor() {
        backgroundColor = UIColor.appColor(.myMainBackground)
    }
    
}
