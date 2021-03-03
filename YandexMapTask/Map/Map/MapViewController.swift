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
    
    lazy var bottomFloatingPanelController = FloatingPanelController()
    lazy var searchView = SearchView.fromNib()
    lazy var pickerPinView = PickerPinView.fromNib()
    
    internal let TARGET_LOCATION = YMKPoint(latitude: 42.311081, longitude: 69.240562)
    internal let scale = UIScreen.main.scale
    internal let mapKit = YMKMapKit.sharedInstance()
    internal var userLocationLayer : YMKUserLocationLayer?
    internal let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    internal var searchSession: YMKSearchSession?
    internal var suggestSession: YMKSearchSuggestSession?
    internal let BOUNDING_BOX = YMKBoundingBox(
        southWest: YMKPoint(latitude: 41.44, longitude: 69.04),
        northEast: YMKPoint(latitude: 41.15, longitude: 69.57))
    internal var suggestResults = [Search]()
    internal var centerPoint: YMKPoint?
    
    // MARK: - Data Providers
    private var suggestDataProvider: SuggestDataProvider?

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
            setupBottomFloatingPanel()
            setupMyCurrentLocation()
            setupMapViewListener()
            setupSuggestion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Other funcs
extension MapViewController {
    private func appearanceSettings() {
        searchView.searchBar.delegate = self
        setupMapStyle()
        closeKeyboardOnOutsideTap()
        setupDataProvider()
    }
    
    private func setupDataProvider() {
        let suggestDataProvider = SuggestDataProvider(viewController: self)
        suggestDataProvider.tableView = view().tableView
        self.suggestDataProvider = suggestDataProvider
    }
    
    private  func moveMapView(object: YMKGeoObject, uri: String) {
        guard let target = object.geometry.first?.point else { return }
        view().mapView.mapWindow.map.move(with: YMKCameraPosition(target: target, zoom: 16, azimuth: 0, tilt: 0), animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.2))
    }
    
    private func showDetailViewController(object: YMKGeoObject, uri: String) {
        guard let vc = bottomFloatingPanelController.contentViewController as? DetailViewController else { return }
        vc.isPushed = isPushed
        vc.object = object
        vc.uri = uri
        present(bottomFloatingPanelController, animated: true)
    }
    
    func getLocation(object: YMKGeoObject, uri: String) {
        hideBackView()
        moveMapView(object: object, uri: uri)
        showDetailViewController(object: object, uri: uri)
    }
    
    func showBackView() {
        UIView.animate(withDuration: 0.25) {
            self.view().backView.alpha = 1
            self.view().bringSubviewToFront(self.view().backView)
            self.view().bringSubviewToFront(self.searchView)
            self.searchView.searchBar.setShowsCancelButton(true, animated: true)
        }
    }
    
    func hideBackView() {
        UIView.animate(withDuration: 0.25) {
            self.view().backView.alpha = 0
            self.searchView.searchBar.setShowsCancelButton(false, animated: true)
        }
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
        showBackView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideBackView()
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
    
    func setupSuggestion() {
        suggestSession = searchManager.createSuggestSession()
    }
    
    func search(text : String) {
        let suggestHandler = {(response: [YMKSuggestItem]?, error: Error?) -> Void in
            if let items = response {
                self.onSuggestResponse(items)
            } else {
                self.onError(error!)
            }
        }
        
        suggestSession?.suggest(
            withText: text,
            window: BOUNDING_BOX,
            suggestOptions: YMKSuggestOptions(),
            responseHandler: suggestHandler)
    }
    
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
    
    func getPoint(uri : String) {
        let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
            if let response = searchResponse {
                self.onSearchResponseWithUri(response, uri: uri)
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
    
    func onSearchResponseWithUri(_ response: YMKSearchResponse, uri: String) {
        guard let searchResult = response.collection.children.first, let object = searchResult.obj else { return }
        getLocation(object: object, uri: uri)
    }
    
    func onSuggestResponse(_ items: [YMKSuggestItem]) {
        suggestResults = items.map { Search(title: $0.title.text, address: $0.subtitle?.text, distance: $0.distance?.text, uri: $0.uri) }
        suggestDataProvider?.items = suggestResults
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
        
        showAlert(title: "Error", message: errorMessage)
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

// MARK: - MapKit Style
extension MapViewController {
    
    private func setupMapStyle() {
        view().mapView.mapWindow.map.setMapStyleWithStyle(MapViewController.style())
    }
    
    private static func style() -> String {
        return MapViewController.readRawJson(resourceName: "mapStyle")!
    }

    private static func readRawJson(resourceName: String) -> String? {
        if let filepath: String = Bundle.main.path(forResource: resourceName, ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                NSLog("JsonError: Contents could not be loaded from json file: " + resourceName)
                return nil
            }
        } else {
            NSLog("JsonError: json file not found: " + resourceName)
            return nil
        }
    }
}
