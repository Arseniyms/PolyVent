//
//  TabBarViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//
//

import UIKit

class TabBarViewController: UITabBarController {
    let customTabBar = CustomTabBar()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(customTabBar, forKey: "tabBar")

        setupUI()
        selectedIndex = 1
        middleButton.backgroundColor = .blue
        profileImageView.tintColor = .white
    }

    private let middleButtonDiameter: CGFloat = 42

    private lazy var profileImageView: UIImageView = {
        let heartImageView = UIImageView()
        heartImageView.image = UIImage(named: "face.smiling")?.withRenderingMode(.alwaysTemplate)
        heartImageView.tintColor = .systemGray
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        return heartImageView
    }()

    private lazy var middleButton: UIButton = {
        let middleButton = UIButton()
        middleButton.layer.cornerRadius = middleButtonDiameter / 2
        middleButton.backgroundColor = .customBackgroundColor
        middleButton.addTarget(self, action: #selector(didPressMiddleButton), for: .touchUpInside)
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        return middleButton
    }()

    @objc private func didPressMiddleButton() {
        selectedIndex = 1
        middleButton.backgroundColor = .blue
        profileImageView.tintColor = .white
    }

    func setupUI() {
        tabBar.addSubview(middleButton)
        middleButton.addSubview(profileImageView)
        self.delegate = self
        NSLayoutConstraint.activate([
            middleButton.heightAnchor.constraint(equalToConstant: middleButtonDiameter),
            middleButton.widthAnchor.constraint(equalToConstant: middleButtonDiameter),
            
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10),
            
            profileImageView.heightAnchor.constraint(equalToConstant: 25),
            profileImageView.widthAnchor.constraint(equalToConstant: 25),
            profileImageView.centerXAnchor.constraint(equalTo: middleButton.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: middleButton.centerYAnchor),
        ])
        
        self.tabBar.tintColor = .dynamic(light: .black, dark: .white)
        let events = EventsRouter.createModule(eventsClassification: .all)
        let saved = EventsRouter.createModule(eventsClassification: .saved)
        let profile = ProfileRouter.createModule()
        events.tabBarItem = UITabBarItem(title: Constants.TabBarItemsNames.allEvents,
                                         image: UIImage(named: "magnifyingglass.circle"), tag: 1)
        events.tabBarItem.selectedImage = UIImage(named: "magnifyingglass.circle.fill")
        saved.tabBarItem = UITabBarItem(title: Constants.TabBarItemsNames.registeredTickets,
                                        image: UIImage(named: "ticket"), tag: 3)
        saved.tabBarItem.selectedImage = UIImage(named: "ticket.fill")
        self.setViewControllers([events, profile, saved], animated: true)
        
    }

    private func animate(_ view: UIView) {
        let timeInterval: TimeInterval = 0.3
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 1) {
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({ view.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    override func tabBar(_: UITabBar, didSelect item: UITabBarItem) {
        let selectedIndex = self.tabBar.items?.firstIndex(of: item)
        if selectedIndex == 1 {
            middleButton.backgroundColor = .blue
            profileImageView.tintColor = .white
            animate(profileImageView)
        } else {
            middleButton.backgroundColor = .customBackgroundColor
            profileImageView.tintColor = .gray
            guard let barItemView = item.value(forKey: "view") as? UIView else { return }
            animate(barItemView)
        }
    }
    
}

