//
//  BasePresenter.swift
//  NetworkLayer
//
//  Created by Asmaa Tarek on 05/05/2021.
//

import Foundation
import JGProgressHUD
import PromiseKit

protocol BasePresenterProtocol {
    
}

class BasePresenter: BasePresenterProtocol {
    var baseView: BaseViewProtocol!
    var hud: JGProgressHUD?
    
    init(baseView: BaseViewProtocol) {
        self.baseView = baseView
    }
    
    func startRequest<M: Codable>(request: NetworkAPI, mappingClass: M.Type,showIndicator: Bool = true) -> Promise<M> {
        if showIndicator {
            hud = baseView.showProgressHub()
        }
        
        return Promise { seal in
            NetworkManager.shared.fetchData(request: request, mappingClass: M.self).done { response in
                seal.fulfill(response)
            }.ensure {[weak self] in
                self?.baseView.dismissProgressHub(hud: self?.hud)
            }.catch(policy: .allErrors) {[weak self] error in
                self?.baseView.showAlert(message: (error as? HTTPErrors)?.rawValue ?? "")
            }
        }
    }
}
