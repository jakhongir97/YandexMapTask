//
//  MapViewController.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

class MapViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    // MARK: - Root View
    typealias RootView = MapView
    
    // MARK: - Services
    internal var coordinator: MapCoordinator?
    internal let viewModel = MapViewModel()
    
    lazy var searchView = SearchView.fromNib()
    lazy var pickerPinView = PickerPinView.fromNib()
    
    // MARK: - Data Providers

    // MARK: - Attributes
    override var prefersStatusBarHidden: Bool { return false }
    
    // MARK: - Actions
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        setupSearchView()
        setupMyLocationButton()
        setupPickerPinView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - Networking
extension MapViewController : MapViewModelProtocol {
    func didFinishFetch(data: Data) {
        
    }
}

// MARK: - Other funcs
extension MapViewController {
    private func appearanceSettings() {
        viewModel.delegate = self
    }
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
    }
    
    func setupPickerPinView() {
        view().addSubview(pickerPinView)
        
        pickerPinView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-pickerPinView.frame.height/2)
        }
        
        view().myLocationButton.addTarget(self, action: #selector(myLocationButtonAction(sender:)), for: .touchUpInside)
    }
}

// MARK: - Functions
extension MapViewController {
    
    @objc func myLocationButtonAction(sender: UIButton) {
        sender.showAnimation { [weak self] in
            
        }
    }
    
}
