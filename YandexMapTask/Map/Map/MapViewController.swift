//
//  MapViewController.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit
import YandexMapsMobile
import FloatingPanel

class MapViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    // MARK: - Root View
    typealias RootView = MapView
    
    // MARK: - Services
    internal var coordinator: MapCoordinator?
    internal let viewModel = MapViewModel()
    
    lazy var floatingPanelController = FloatingPanelController()
    lazy var bottomFloatingPanelController = FloatingPanelController()
    lazy var floatingPanelDelegate = FloatingPanelDelegate(owner: self)
    lazy var searchView = SearchView.fromNib()
    lazy var pickerPinView = PickerPinView.fromNib()
    
    internal let TARGET_LOCATION = YMKPoint(latitude: 42.311081, longitude: 69.240562)
    internal let scale = UIScreen.main.scale
    internal let mapKit = YMKMapKit.sharedInstance()
    internal var userLocationLayer : YMKUserLocationLayer?
    internal let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    internal var searchSession: YMKSearchSession?
    
    // MARK: - Data Providers

    // MARK: - Attributes
    override var prefersStatusBarHidden: Bool { return false }
    
    // MARK: - Actions
    @objc func myLocationButtonAction(sender: UIButton) {
        sender.showAnimation { [weak self] in
            self?.centerMyCurrentLocation()
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        setupSearchView()
        setupMyLocationButton()
        setupPickerPinView()
        setupFloatingPanel()
        setupBottomFloatingPanel()
        setupMyCurrentLocation()
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
        searchView.searchBar.delegate = self
        closeKeyboardOnOutsideTap()
    }
}

// MARK: - SuggestViewControllerDelegate
extension MapViewController : SuggestViewControllerDelegate {
    func getLocation(object: YMKGeoObject, uri: String) {
        floatingPanelController.dismiss(animated: true)
        guard let target = object.geometry.first?.point else { return }
        view().mapView.mapWindow.map.move(with: YMKCameraPosition(target: target, zoom: 16, azimuth: 0, tilt: 0), animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.2))
        guard let vc = bottomFloatingPanelController.contentViewController as? DetailViewController else { return }
        vc.object = object
        vc.uri = uri
        present(bottomFloatingPanelController, animated: true)
    }
}

// MARK: - DetailViewControllerDelegate
extension MapViewController : DetailViewControllerDelegate {
    func close() {
        bottomFloatingPanelController.dismiss(animated: true)
        searchView.searchBar.resignFirstResponder()
    }
    
    
}

// MARK: - UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.present(self.floatingPanelController, animated: true)
        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
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
    
    private func setupFloatingPanel() {
        floatingPanelController.contentMode = .fitToBounds
        floatingPanelController.layout = MyFloatingPanelLayout()
        floatingPanelController.delegate = floatingPanelDelegate
        floatingPanelController.isRemovalInteractionEnabled = true
        
        let suggestViewController = SuggestViewController()
        suggestViewController.delegate = self
        floatingPanelController.set(contentViewController: suggestViewController)
        floatingPanelController.track(scrollView: suggestViewController.view().tableView)
        
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 15.0
        appearance.backgroundColor = .clear
        floatingPanelController.surfaceView.appearance = appearance
    }
    
    private func setupBottomFloatingPanel() {
        bottomFloatingPanelController.contentMode = .fitToBounds
        bottomFloatingPanelController.layout = MyBottomFloatingPanelLayout()
        bottomFloatingPanelController.delegate = floatingPanelDelegate
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

// MARK: - FloatingPanelDelegate
class FloatingPanelDelegate: NSObject, FloatingPanelControllerDelegate {
    
    unowned let owner: MapViewController
    
    init(owner: MapViewController) {
        self.owner = owner
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        owner.view().setNeedsLayout()
        owner.view().layoutIfNeeded()
        
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {

    }
    
    func floatingPanelWillEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        
    }
    
}

// MARK: - MyFloatingPanelLayout
class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 0.0, edge: .top, referenceGuide: .safeArea),
        ]
    }
    
}

// MARK: - MyBottomFloatingPanelLayout
class MyBottomFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 194.0, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    
}

// MARK: - MapKit Search
extension MapViewController {
    
    func search(point : YMKPoint) {
        let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
            if let response = searchResponse {
                self.onSearchResponse(response)
            } else {
                self.onError(error!)
            }
        }
        
        searchSession = searchManager.submit(with: point, zoom: nil, searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
    }
    
    func onSearchResponse(_ response: YMKSearchResponse) {
        guard let searchResult = response.collection.children.first else { return }
        if let text = searchResult.obj?.name {
            
        }
    }

    func onError(_ error: Error) {
        let suggestError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if suggestError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if suggestError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - MapKit User Location
extension MapViewController : YMKUserLocationObjectListener {
    
    func centerMyCurrentLocation() {
        guard let target = userLocationLayer?.cameraPosition()?.target else { return }
        view().mapView.mapWindow.map.move(with: YMKCameraPosition(target: target, zoom: 16, azimuth: 0, tilt: 0), animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.2))
    }
    
    func setupMyCurrentLocation() {
        view().mapView.mapWindow.map.isRotateGesturesEnabled = false
        view().mapView.mapWindow.map.move(with: YMKCameraPosition(target: TARGET_LOCATION, zoom: 16, azimuth: 0, tilt: 0))
        
        userLocationLayer = mapKit.createUserLocationLayer(with: view().mapView.mapWindow)
        
        userLocationLayer?.setVisibleWithOn(true)
        userLocationLayer?.isHeadingEnabled = true
        userLocationLayer?.setObjectListenerWith(self)
        
        userLocationLayer?.setAnchorWithAnchorNormal(CGPoint(x: 0.5 * view().mapView.frame.size.width * scale, y: 0.5 * view().mapView.frame.size.height * scale),
                                                    anchorCourse: CGPoint(x: 0.5 * view().mapView.frame.size.width * scale, y: 0.5 * view().mapView.frame.size.height * scale))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.userLocationLayer?.resetAnchor()
        }
    }
    
    func onObjectAdded(with view: YMKUserLocationView) {
        
        let pinPlacemark = view.pin.useCompositeIcon()

        pinPlacemark.setIconWithName(String(describing: pinPlacemark.self),
                                     image: UIImage.appImage(.circlePin),
                                     style: YMKIconStyle(anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                                                         rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                                                         zIndex: 1,
                                                         flat: true,
                                                         visible: true,
                                                         scale: 1.5,
                                                         tappableArea: nil))

        view.accuracyCircle.fillColor = UIColor.appColor(.myBlue).withAlphaComponent(0.2)
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}

}
