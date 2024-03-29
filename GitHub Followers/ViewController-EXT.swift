//
//  ViewControllerEXT.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 08/02/2024.
//

import UIKit
import SafariServices

fileprivate var containerView : UIView!

extension UIViewController {
    
    func presentGFAlert(alertTitle: String = "Opps!", messageText: String, buttonTitle: String = "OK"){
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: alertTitle , messageText: messageText, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentDefaultError() {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: "Something Went Wrong",
                                    messageText: "We were unable to complete your task at this time. Please try again.",
                                    buttonTitle: "Ok")
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0.0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showEmptyStateViewWith(message: String, superView: UIView){
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = superView.bounds
        superView.addSubview(emptyStateView)
    }
    
    func presentToSafariVC(url urlString: String) {
        guard let url = URL(string: urlString) else {
            presentGFAlert(alertTitle: "Invalid URL", messageText: "The site you are trying to reach is invalid", buttonTitle: "OK")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .accent
        safariVC.modalPresentationStyle = .formSheet
        present(safariVC, animated: true)
    }
    
}
