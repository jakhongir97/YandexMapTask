//
//  AddressView.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

final class AddressView: CustomView {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: AddressCollectionViewCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: AddressCollectionViewCell.defaultReuseIdentifier)
        }
    }
    
}
