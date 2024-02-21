//
//  UserInfoVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 13/02/2024.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject{
    func newFollowersRequested(username: String)
}

class UserInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureContentViews()
        configureViews()
        fetchUserInfo()
    }
    
    func fetchUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureChildVCs(user: user) }
            case .failure(let error):
                self.presentGFAlert(messageText: error.rawValue)
            }
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    private func configureChildVCs(user: User) {
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: GFRepoItemVC(for: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(for: user, delegate: self), to: self.itemViewTwo)
        
        self.dateLabel.text = "Github since \(user.createdAt.formatted(.dateTime.year().month(.abbreviated)))"
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        let doneNavButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneNavButton
    }
    
    func configureContentViews() {
        [scrollView, contentView].forEach {$0.translatesAutoresizingMaskIntoConstraints = false}
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
    }
    
    func configureViews() {
        [ headerView, itemViewOne, itemViewTwo, dateLabel ].forEach { vcElement in
            contentView.addSubview(vcElement)
            vcElement.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let padding:CGFloat = 20
        let itemHeight:CGFloat = 140
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
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
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
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
    let dateLabel = GFBodyLabel(textAlignment: .center)
    let contentView = UIView()
    let scrollView = UIScrollView()

    var username: String!
    
    weak var delegate: UserInfoVCDelegate!
    
}


extension UserInfoVC: GFRepoItemVCDelegate{
    func githubProfilDidTapped(for user: User) {
        presentToSafariVC(url: user.htmlUrl)
    }
}

extension UserInfoVC: GFFollowerItemVCDelegate{
    func getFollowersDidTapped(for user: User) {
        guard user.followers != 0 else {
            presentGFAlert(alertTitle: "No followers", messageText: "This user has no followers. What a shame 😞.", buttonTitle: "So sad")
            return
        }
        delegate.newFollowersRequested(username: user.login)
        dismissVC()
    }
}
