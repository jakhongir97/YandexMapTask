//
//  MapView.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit
import YandexMapsMobile
import SnapKit
import FloatingPanel

final class MapView: CustomView {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: YMKMapView!
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.alpha = 0
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: SuggestTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SuggestTableViewCell.defaultReuseIdentifier)
        }
    }
    
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

// MARK: - Constraints
extension MapViewController {
    
    func setupSearchView() {
        view().addSubview(searchView)
        
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(view().safeAreaLayoutGuide.snp.topMargin).inset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupMyLocationButton() {
        view().addSubview(view().myLocationButton)
        
        view().myLocationButton.snp.makeConstraints { (make) in
            make.width.equalTo(52)
            make.height.equalTo(52)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        view().myLocationButton.addTarget(self, action: #selector(myLocationButtonAction(sender:)), for: .touchUpInside)
    }
    
    func setupInfoButton() {
        view().addSubview(view().infoButton)
        
        view().infoButton.snp.makeConstraints { (make) in
            make.width.equalTo(52)
            make.height.equalTo(52)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        view().infoButton.addTarget(self, action: #selector(infoButtonAction(sender:)), for: .touchUpInside)
    }
    
    func setupBackButton() {
        view().addSubview(view().backButton)
        
        view().backButton.snp.makeConstraints { (make) in
            make.width.equalTo(52)
            make.height.equalTo(52)
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(view().safeAreaLayoutGuide.snp.topMargin).inset(20)
        }
        
        view().backButton.addTarget(self, action: #selector(backButtonAction(sender:)), for: .touchUpInside)
    }
    
    func setupPickerPinView() {
        view().addSubview(pickerPinView)
        
        pickerPinView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-pickerPinView.frame.height/2)
        }
    }
    
    func setupBottomFloatingPanel() {
        bottomFloatingPanelController.contentMode = .fitToBounds
        bottomFloatingPanelController.layout = MyBottomFloatingPanelLayout()
        bottomFloatingPanelController.isRemovalInteractionEnabled = true
        
        let detailViewController = DetailViewController()
        detailViewController.delegate = self
        bottomFloatingPanelController.set(contentViewController: detailViewController)
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 15.0
        appearance.backgroundColor = .clear
        bottomFloatingPanelController.surfaceView.appearance = appearance
    }
}
