//
//  SearchView.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

final class SearchView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.searchTextField.backgroundColor = UIColor.appColor(.myGrayBackground)
            searchBar.updateHeight(height: 36)
            searchBar.tintColor = UIColor.appColor(.myBlack)
            searchBar.showsBookmarkButton = true
            searchBar.setImage(UIImage.appImage(.voice), for: .bookmark, state: .normal)
            searchBar.showsCancelButton = false
        }
    }
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 13
        layer.cornerCurve = .continuous
        
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(equalToConstant: 53.0)
        let widthConstraint = widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40)
        addConstraint(heightConstraint)
        addConstraint(widthConstraint)
    }
    
}
