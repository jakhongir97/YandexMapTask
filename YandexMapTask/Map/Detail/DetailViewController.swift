//
//  DetailViewController.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 29/01/21.
//

import UIKit
import YandexMapsMobile

protocol DetailViewControllerDelegate: class {
    func close()
}

class DetailViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    // MARK: - Root View
    typealias RootView = DetailView
    
    // MARK: - Services
    weak var delegate: DetailViewControllerDelegate?
    private let coreDataController = CoreDataController(persistenceManager: .shared)

    // MARK: - Attributes
    override var prefersStatusBarHidden: Bool { return false }
    
    var uri : String?
    var object : YMKGeoObject? {
        didSet {
            guard let object = object else { return }
            view().nameLabel.text = object.name
            view().addressLabel.text = object.descriptionText
        }
    }
    
    
    // MARK: - Actions
    @IBAction func addButtonAction(_ sender: UIButton) {
        guard let object = object, let uri = uri else { return }
        showAlertWithTextField(title: "", message: "Добавить адрес в избранное", placeholder: object.name ?? "") { name in
            self.coreDataController.addOfflineSearch(uri: uri, name: name, address: object.descriptionText)
            self.delegate?.close()
        }
        
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        delegate?.close()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - Other funcs
extension DetailViewController {
    private func appearanceSettings() {
        
    }
}
