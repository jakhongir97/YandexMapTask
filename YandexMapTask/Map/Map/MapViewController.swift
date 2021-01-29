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
    internal var centerPoint: YMKPoint?
    
    // MARK: - Data Providers

    // MARK: - Attributes
    override var prefersStatusBarHidden: Bool { return false }
    internal var isPushed = false
    
    // MARK: - Actions
    @objc func myLocationButtonAction(sender: UIButton) {
        sender.showAnimation { [weak self] in
            self?.centerMyCurrentLocation()
        }
    }
    
    @objc func infoButtonAction(sender: UIButton) {
        sender.showAnimation { }
        guard let centerPoint = centerPoint else { return }
        search(point: centerPoint)
    }
    
    @objc func backButtonAction(sender: UIButton) {
        sender.showAnimation {[weak self] in
            self?.bottomFloatingPanelController.dismiss(animated: true)
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPushed {
            appearanceSettings()
            setupBackButton()
            setupBottomFloatingPanel()
        } else {
            appearanceSettings()
            setupSearchView()
            setupMyLocationButton()
            setupInfoButton()
            setupPickerPinView()
            setupFloatingPanel()
            setupBottomFloatingPanel()
            setupMyCurrentLocation()
            setupMapViewListener()
        }
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
    
    private func showDetailViewController(object: YMKGeoObject, uri: String) {
        guard let vc = bottomFloatingPanelController.contentViewController as? DetailViewController else { return }
        vc.isPushed = isPushed
        vc.object = object
        vc.uri = uri
        present(bottomFloatingPanelController, animated: true)
    }
}

// MARK: - SuggestViewControllerDelegate
extension MapViewController : SuggestViewControllerDelegate {
    func getLocation(object: YMKGeoObject, uri: String) {
        floatingPanelController.dismiss(animated: true)
        guard let target = object.geometry.first?.point else { return }
        view().mapView.mapWindow.map.move(with: YMKCameraPosition(target: target, zoom: 16, azimuth: 0, tilt: 0), animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.2))
        showDetailViewController(object: object, uri: uri)
    }
}

// MARK: - DetailViewControllerDelegate
extension MapViewController : DetailViewControllerDelegate {
    func close() {
        bottomFloatingPanelController.dismiss(animated: true)
        searchView.searchBar.resignFirstResponder()
        if isPushed {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
}

// MARK: - UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
//            let vc = SuggestViewController()
//            self.present(vc, animated: true)
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
    
    func search(uri : String) {
        let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
            if let response = searchResponse {
                self.onSearchResponse(response)
            } else {
                self.onError(error!)
            }
        }
        
        searchSession = searchManager.resolveURI(withUri: uri, searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
    }
    
    func onSearchResponse(_ response: YMKSearchResponse) {
        guard let searchResult = response.collection.children.first, let object = searchResult.obj else { return }
        guard let metadata = searchResult.obj?.metadataContainer.getItemOf(YMKUriObjectMetadata.self) as? YMKUriObjectMetadata, let uri = metadata.uris.first?.value else { return }
        if isPushed {
            getLocation(object: object, uri: uri)
            guard let point = object.geometry.first?.point else { return }
            drawPlaceMark(point: point)
        } else {
            showDetailViewController(object: object, uri: uri)
        }
    }
    
    func drawPlaceMark(point : YMKPoint) {
        let mapObjects = view().mapView.mapWindow.map.mapObjects
        let mark = mapObjects.addPlacemark(with: point)
        mark.setIconWith(UIImage.appImage(.pin))
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

// MARK: - MapKit Camera Position
extension MapViewController : YMKMapCameraListener {
    private func setupMapViewListener() {
        view().mapView.mapWindow.map.addCameraListener(with: self)
    }
    
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
        if finished {
            self.centerPoint = cameraPosition.target
        }
    }
}
