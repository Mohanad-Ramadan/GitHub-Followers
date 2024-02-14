//
//  GFItemInfoVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 14/02/2024.
//

import UIKit

class GFItemInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureViews()
        configureButtonAction()
    }
    
    init(user: User!) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    private func configureVC() {
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 18
    }
    
    private func configureViews() {
        [stackView, actionButton].forEach { subViews in
            view.addSubview(subViews)
            subViews.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [itemInfoViewOne, itemInfoViewTwo].forEach { stackView.addArrangedSubview($0) }
        
        let padding:CGFloat = 20
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureButtonAction() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    @objc func actionButtonTapped() {}
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    let itemInfoViewOne = GFItemInfoView()
    let itemInfoViewTwo = GFItemInfoView()
    let actionButton = GFButton()
    
    var user: User!
    weak var delegate: UserInfoVCDelegate!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
