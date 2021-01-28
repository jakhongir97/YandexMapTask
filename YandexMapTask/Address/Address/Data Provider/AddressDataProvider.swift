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
    
    internal var items = [Notification]() {
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCollectionViewCell.defaultReuseIdentifier, for: indexPath) as? AddressCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 26.0, height: 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
