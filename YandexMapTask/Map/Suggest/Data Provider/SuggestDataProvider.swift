//
//  SearchDataProvider.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 29/01/21.
//

import UIKit

final class SuggestDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    // MARK: - Attributes
    weak var viewController: UIViewController?
    
    internal var items = [Search]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    // MARK: - Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SuggestTableViewCell.defaultReuseIdentifier, for: indexPath) as? SuggestTableViewCell else { return UITableViewCell() }
        cell.nameLabel.text = items[indexPath.row].title
        cell.addressLabel.text = items[indexPath.row].address
        cell.distanceLabel.text = items[indexPath.row].distance
        return cell
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = viewController as? SuggestViewController else { return }
        guard let uri = items[indexPath.row].uri else { return }
        vc.getPoint(uri: uri)
    }
    
}
