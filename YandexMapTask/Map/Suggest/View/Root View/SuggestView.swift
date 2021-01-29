//
//  SearchView.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 29/01/21.
//

import UIKit

final class SuggestView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: SuggestTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SuggestTableViewCell.defaultReuseIdentifier)
        }
    }
    
}
