//
//  SearchViewModel.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 29/01/21.
//

import UIKit

protocol SuggestViewModelProtocol: class {
    func didFinishFetch(data : Data)
}

final class SuggestViewModel {
    
    // MARK: - Attributes
    weak var delegate: SuggestViewModelProtocol?
    
    // MARK: - Network call
   
}
