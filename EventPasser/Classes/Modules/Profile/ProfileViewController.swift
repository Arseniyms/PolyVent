//
//  ProfileViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//
//

import CoreData
import UIKit

class ProfileViewController: ScrollableViewController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        setupNavigationItems()
        setupScrollView()
        setupScrollContentView()
        setupUI()
    }

    // MARK: - Properties

    var presenter: ViewToPresenterProfileProtocol?

    private lazy var qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .dynamic(light: .black, dark: .white)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.customBackgroundColor.cgColor
        
        imageView.isUserInteractionEnabled = true
        let interaction = UIContextMenuInteraction(delegate: self)
        imageView.addInteraction(interaction)
        return imageView
    }()

    private lazy var warningTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .caption2)
        textView.alpha = 0.6
        textView.isEditable = false
        textView.isSelectable = false
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        
        textView.text = "Это ваш личный QR-код для прохода на мероприятия. На входе вас могут попросить документы."
        return textView
    }()
    
    private lazy var nameLabel: InfoLabel = InfoLabel.profileInfo(of: "Загрузка...")
    private lazy var lastNameLabel: InfoLabel = InfoLabel.profileInfo(of: "Загрузка...")
    private lazy var ageLabel: InfoLabel = InfoLabel.profileInfo(of: "Загрузка...")
    private lazy var emailLabel: InfoLabel = InfoLabel.profileInfo(of: "Загрузка...")
    private lazy var groupLabel: InfoLabel = InfoLabel.profileInfo(of: "Загрузка")
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [qrCodeImageView,
                                                       warningTextView,
                                                       nameLabel,
                                                       lastNameLabel,
                                                       ageLabel,
                                                       emailLabel,
                                                       groupLabel
                                                      ]
        )
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally

        stackView.setCustomSpacing(30, after: warningTextView)
        return stackView
    }()

    private lazy var scrollContentView: UIView = .init()

    // MARK: - Functions

    func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выход", style: .plain, target: self,
                                                           action: #selector(exitButtonTapped))
        
        let edit = UIBarButtonItem(title: "Изм.", style: .plain, target: self,
                                   action: #selector(editButtonTapped))
        
        navigationItem.rightBarButtonItems = [edit]

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func setupScrollContentView() {
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollContentView)
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            scrollContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
        
        self.navigationController?.navigationBar.tintColor = .buttonColor

    }

    func setupUI() {
        view.backgroundColor = .customBackgroundColor

        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20),
        ])

        _ = stackView.subviews.dropFirst().map {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 40).isActive = true
            $0.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -40).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }

        qrCodeImageView.layoutIfNeeded()
        let transition = CATransition()
        transition.duration = 2.0
        transition.type = .reveal

        _ = self.stackView.subviews.dropFirst().map {
            $0.layer.add(transition, forKey: "imageReveal")
        }

        let interaction = UIContextMenuInteraction(delegate: self)
        qrCodeImageView.addInteraction(interaction)
        
        nameLabel.layoutIfNeeded()
        nameLabel.shimmerEffectView()
        lastNameLabel.layoutIfNeeded()
        lastNameLabel.shimmerEffectView()
        ageLabel.layoutIfNeeded()
        ageLabel.shimmerEffectView()
        emailLabel.layoutIfNeeded()
        emailLabel.shimmerEffectView()
        groupLabel.layoutIfNeeded()
        groupLabel.shimmerEffectView()
        
    }

    @objc private func exitButtonTapped() {
        presenter?.goToSignIn()
    }

    @objc private func editButtonTapped() {
        presenter?.goToEditProfile()
    }
}

extension ProfileViewController: PresenterToViewProfileProtocol {
    func updateUserInfo(_ user: UserEntity) {
        nameLabel.text = user.wrappedName
        lastNameLabel.text = user.wrappedLastName
        emailLabel.text = user.wrappedEmail
        ageLabel.text = "\(user.wrappedAge)"
        groupLabel.text = user.group
        
        self.nameLabel.shimmerStopAnimate()
        self.ageLabel.shimmerStopAnimate()
        self.lastNameLabel.shimmerStopAnimate()
        self.emailLabel.shimmerStopAnimate()
        self.groupLabel.shimmerStopAnimate()
        
        let transition = CATransition()
        transition.duration = 1
        transition.type = .fade
        nameLabel.layer.add(transition, forKey: "infoReveal")
        lastNameLabel.layer.add(transition, forKey: "infoReveal")
        ageLabel.layer.add(transition, forKey: "infoReveal")
        emailLabel.layer.add(transition, forKey: "infoReveal")
        groupLabel.layer.add(transition, forKey: "infoReveal")
    }

    func updateQrImage(with image: UIImage) {
        qrCodeImageView.layer.borderColor = UIColor.buttonColor.cgColor

        qrCodeImageView.image = image
            .withInset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)) ?? UIImage(named: "xmark.circle")!

        qrCodeImageView.image = qrCodeImageView.image?.withRenderingMode(.alwaysTemplate)
        let transition = CATransition()
        transition.duration = 1.5
        transition.type = .fade
        qrCodeImageView.layer.add(transition, forKey: "imageReveal")
    }
}

extension ProfileViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu()
        })
        
    }
    
    func makeContextMenu() -> UIMenu {
        
        let edit = UIAction(title: "Изменить профиль", image: UIImage(systemName: "pencil")) { _ in
            self.presenter?.goToEditProfile()
        }
        
        return UIMenu(title: "", children: [edit])
    }
}
