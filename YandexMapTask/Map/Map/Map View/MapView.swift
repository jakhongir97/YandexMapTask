//
//  MapView.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit
import YandexMapsMobile
import SnapKit

final class MapView: CustomView {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: YMKMapView!
    
    lazy var myLocationButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage.appImage(.myLocation), for: .normal)
        button.backgroundColor = UIColor.appColor(.mySecondBackground)
        button.layer.cornerRadius = 26
        button.layer.cornerCurve = .continuous
        button.tintColor = UIColor.appColor(.myBlack)
        return button
    }()
    
    lazy var infoButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info"), for: .normal)
        button.backgroundColor = UIColor.appColor(.mySecondBackground)
        button.layer.cornerRadius = 26
        button.layer.cornerCurve = .continuous
        button.tintColor = UIColor.appColor(.myBlack)
        return button
    }()
    
    lazy var backButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.backgroundColor = UIColor.appColor(.mySecondBackground)
        button.layer.cornerRadius = 26
        button.layer.cornerCurve = .continuous
        button.tintColor = UIColor.appColor(.myBlack)
        return button
    }()
    
}
