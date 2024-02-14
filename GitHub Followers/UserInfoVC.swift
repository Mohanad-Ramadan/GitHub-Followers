//
//  UserInfoVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 13/02/2024.
//

import UIKit

class UserInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureViews()
        fetchUserInfo()
    }
    
    func fetchUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView) }
            case .failure(let error):
                self.presentGFAlertOnMainThread(alertTitle: "Opps!", messageText: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        let doneNavButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneNavButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func configureViews() {
        [ headerView, itemViewOne, itemViewTwo ].forEach { vcView in
            view.addSubview(vcView)
            vcView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        itemViewOne.backgroundColor = .systemGray
        itemViewTwo.backgroundColor = .systemBlue
        
        let padding:CGFloat = 20
        let itemHeight:CGFloat = 140
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
 
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()

    var username: String!
    
}
