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
        return button
    }()
    
}
