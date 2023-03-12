//
//  TabBarViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//
//

import UIKit

class TabBarViewController: UITabBarController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        selectedIndex = 2
    }

    private lazy var profileImageView: UIImageView = {
        let heartImageView = UIImageView()
        heartImageView.image = UIImage(named: "face.smiling")?.withRenderingMode(.alwaysTemplate)
        heartImageView.tintColor = .systemGray
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        return heartImageView
    }()
    
    func setupUI() {
        self.delegate = self
        self.tabBar.tintColor = .dynamic(light: .black, dark: .white)
        let events = EventsRouter.createModule(eventsClassification: .all)
        let saved = EventsRouter.createModule(eventsClassification: .saved)
        let profile = ProfileRouter.createModule()
        events.tabBarItem = UITabBarItem(title: Constants.TabBarItemsNames.allEvents,
                                         image: UIImage(systemName: "magnifyingglass.circle"), tag: 1)
        events.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        saved.tabBarItem = UITabBarItem(title: Constants.TabBarItemsNames.registeredTickets,
                                        image: UIImage(systemName: "ticket") ?? UIImage(named: "ticket"), tag: 2)
        saved.tabBarItem.selectedImage = UIImage(systemName: "ticket.fill") ?? UIImage(named: "ticket.fill")
        profile.tabBarItem = UITabBarItem(title: Constants.TabBarItemsNames.profile,
                                          image: UIImage(systemName: "person.crop.circle"), tag: 3)
        profile.tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        self.setViewControllers([events, saved, profile], animated: true)
        
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
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        animate(barItemView)
    }
    
}

