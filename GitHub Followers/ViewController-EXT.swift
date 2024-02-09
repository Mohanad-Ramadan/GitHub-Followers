//
//  ViewControllerEXT.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 08/02/2024.
//

import UIKit

extension UIViewController {
    
    func presentGFAlertOnMainThread(alertTitle: String, messageText: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: alertTitle, messageText: messageText, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentDefaultError() {
        let alertVC = GFAlertVC(alertTitle: "Something Went Wrong",
                                messageText: "We were unable to complete your task at this time. Please try again.",
                                buttonTitle: "Ok")
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        present(alertVC, animated: true)
    }
    
    
}
