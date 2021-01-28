//
//  MapViewModel.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

protocol MapViewModelProtocol: class {
    func didFinishFetch(data : Data)
}

final class MapViewModel {
    
    // MARK: - Attributes
    weak var delegate: MapViewModelProtocol?
    
    // MARK: - Network call
   
}
