//
//  SearchViewController.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 29/01/21.
//

import UIKit
import YandexMapsMobile

protocol SuggestViewControllerDelegate: class {
    func getLocation(object: YMKGeoObject, uri:  String)
}

class SuggestViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    // MARK: - Root View
    typealias RootView = SuggestView
    
    // MARK: - Services
    internal var coordinator: MapCoordinator?
    internal let viewModel = SuggestViewModel()
    weak var delegate: SuggestViewControllerDelegate?
    
    lazy var searchView = SearchView.fromNib()
    
    internal var suggestResults = [Search]()
    internal let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    internal var suggestSession: YMKSearchSuggestSession?
    internal var searchSession: YMKSearchSession?
    internal let BOUNDING_BOX = YMKBoundingBox(
        southWest: YMKPoint(latitude: 41.44, longitude: 69.04),
        northEast: YMKPoint(latitude: 41.15, longitude: 69.57))
    
    // MARK: - Data Providers
    private var suggestDataProvider: SuggestDataProvider?

    // MARK: - Attributes
    override var prefersStatusBarHidden: Bool { return false }
    
    // MARK: - Actions
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        setupSearchView()
        setupSuggestion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - Networking
extension SuggestViewController : SuggestViewModelProtocol {
    func didFinishFetch(data: Data) {
        
    }
}

// MARK: - Other funcs
extension SuggestViewController {
    private func appearanceSettings() {
        viewModel.delegate = self
        searchView.searchBar.delegate = self
        searchView.searchBar.becomeFirstResponder()
        
        let suggestDataProvider = SuggestDataProvider(viewController: self)
        suggestDataProvider.tableView = view().tableView
        self.suggestDataProvider = suggestDataProvider
    }
    
    func setupSearchView() {
        view().addSubview(searchView)
        
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(view().safeAreaLayoutGuide.snp.topMargin).inset(20)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - UISearchBarDelegate
extension SuggestViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
}

// MARK: - MapKit Search
extension SuggestViewController {
    
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
    
    func getPoint(uri : String) {
        let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
            if let response = searchResponse {
                self.onSearchResponse(response, uri: uri)
            } else {
                self.onError(error!)
            }
        }
        searchSession = searchManager.resolveURI(withUri: uri, searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
    }
    
    func onSearchResponse(_ response: YMKSearchResponse, uri: String) {
        guard let searchResult = response.collection.children.first, let object = searchResult.obj else { return }
        delegate?.getLocation(object: object, uri: uri)
    }
    
    func onSuggestResponse(_ items: [YMKSuggestItem]) {
        suggestResults = items.map { Search(title: $0.title.text, address: $0.subtitle?.text, distance: $0.distance?.text, uri: $0.uri) }
        suggestDataProvider?.items = suggestResults
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


