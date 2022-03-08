//
//  BaseController.swift
//  NetworkLayer
//
//  Created by Asmaa Tarek on 05/05/2021.
//

import Foundation
import JGProgressHUD

protocol BaseViewProtocol {
    func showProgressHub() -> JGProgressHUD
    func dismissProgressHub(hud: JGProgressHUD?)
    func showAlert(message: String) 
}

class BaseController: UIViewController, BaseViewProtocol {
    func showProgressHub() -> JGProgressHUD {
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        return hud
    }
    
    func dismissProgressHub(hud: JGProgressHUD?){
        hud?.dismiss()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
