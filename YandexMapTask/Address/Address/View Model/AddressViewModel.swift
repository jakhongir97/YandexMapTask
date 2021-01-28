//
//  AddressViewModel.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

protocol AddressViewModelProtocol: class {
    func didFinishFetch(data : Data)
}

final class AddressViewModel {
    
    // MARK: - Attributes
    weak var delegate: AddressViewModelProtocol?
    
    // MARK: - Network call
   
}
