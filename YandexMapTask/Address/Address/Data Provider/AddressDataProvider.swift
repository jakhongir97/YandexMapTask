//
//  AddressDataProvider.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

final class AddressDataProvider: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlets
    weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    // MARK: - Attributes
    weak var viewController: UIViewController?
    
    internal var items = [Search]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    // MARK: - Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCollectionViewCell.defaultReuseIdentifier, for: indexPath) as? AddressCollectionViewCell else { return UICollectionViewCell() }
        cell.nameLabel.text = items[indexPath.row].title
        cell.addressLabel.text = items[indexPath.row].address
        return cell
    }
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 26.0, height: 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = self.viewController as? AddressViewController else { return }
        guard let uri = items[indexPath.row].uri else { return }
        vc.coordinator?.pushMapVC(uri: uri)
    }
    
    // MARK: - Context Menu
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            return nil
        }, actionProvider: { suggestedActions in
            return self.makeContextMenu(indexPath: indexPath)
        })
    }
    
    func makeContextMenu(indexPath: IndexPath) -> UIMenu {
        
        let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash.fill")) { action in
            guard let vc = self.viewController as? AddressViewController else { return }
            guard let uri = self.items[indexPath.row].uri else { return }
            vc.removeData(uri: uri)
            
        }
        
        return UIMenu(title: "", children: [delete])
    }
    
}
