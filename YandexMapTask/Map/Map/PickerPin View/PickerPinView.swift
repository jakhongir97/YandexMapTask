//
//  PickerPinView.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

final class PickerPinView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(equalToConstant: 72.0)
        let widthConstraint = widthAnchor.constraint(equalToConstant: 89)
        addConstraint(heightConstraint)
        addConstraint(widthConstraint)
    }
    
}
