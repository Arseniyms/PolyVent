//
//  EventDescriptionViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 19.11.2022.
//
//

import UIKit

class EventDescriptionViewController: ScrollableViewController {
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

    var presenter: ViewToPresenterEventDescriptionProtocol?

    private lazy var scrollContentView: UIView = .init()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20

        return stackView
    }()

    private lazy var nameLabel: UITextView = {
        let label = UITextView()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.isEditable = false
        label.isSelectable = true
        label.isScrollEnabled = false
        label.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        return label
    }()

    private lazy var calendarImage: UIImageView = {
        let image = UIImage(named: "calendar")
        let imageView = UIImageView.withRoundedBackground(with: image)
        return imageView
    }()

    private lazy var dateLabel: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.isEditable = false
        label.isSelectable = true
        label.isScrollEnabled = false
        label.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        label.textAlignment = .left
        label.textContainer.maximumNumberOfLines = 2
        
        return label
    }()

    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(calendarImage)
        stackView.addArrangedSubview(dateLabel)

        calendarImage.translatesAutoresizingMaskIntoConstraints = false
        calendarImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        calendarImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        return stackView
    }()

    private lazy var addressImage: UIImageView = {
        let image = UIImage(named: "place")
        let imageView = UIImageView.withRoundedBackground(with: image)
        return imageView
    }()

    private lazy var addressLabel: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.isEditable = false
        label.isSelectable = true
        label.isScrollEnabled = false
        label.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        label.textAlignment = .left
        label.textContainer.maximumNumberOfLines = 2
        
        return label
    }()

    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(addressImage)
        stackView.addArrangedSubview(addressLabel)

        addressImage.translatesAutoresizingMaskIntoConstraints = false
        addressImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        addressImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        return stackView
    }()

    private lazy var peopleImage: UIImageView = {
        var image: UIImage? = UIImage()
        image = UIImage(systemName: "person.3.fill")
        let imageView = UIImageView.withRoundedBackground(with: image)
        imageView.image = imageView.image?
            .withInset(UIEdgeInsets(top: 2, left: -1, bottom: 2, right: -1))
        return imageView
    }()

    private lazy var peopleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var peopleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.addArrangedSubview(peopleImage)
        stackView.addArrangedSubview(peopleLabel)

        peopleImage.translatesAutoresizingMaskIntoConstraints = false
        peopleImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        peopleImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        return stackView
    }()

    private lazy var specificationTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        textView.font = .systemFont(ofSize: 20, weight: .light)
        return textView
    }()

    private lazy var signButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        return button
    }()

    // MARK: - Functions

    func setupNavigationItems() {
        self.navigationItem.title = "Описание"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(exitButtonTapped))
    }

    @objc func exitButtonTapped(_: UIButton) {
        self.presenter?.exit()
    }

    func setupScrollContentView() {
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollContentView)
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
    }

    func setupUI() {
        view.backgroundColor = .customBackgroundColor

        stackView.translatesAutoresizingMaskIntoConstraints = false
        specificationTextView.translatesAutoresizingMaskIntoConstraints = false
        signButton.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dateStackView)
        stackView.addArrangedSubview(addressStackView)
        stackView.addArrangedSubview(peopleStackView)
        stackView.addArrangedSubview(self.getInfoLabel("Описание"))

        scrollContentView.addSubview(stackView)
        scrollContentView.addSubview(specificationTextView)
        view.addSubview(signButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),

            specificationTextView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            specificationTextView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -70),
            specificationTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            specificationTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),

            signButton.widthAnchor.constraint(equalToConstant: 300),
            signButton.heightAnchor.constraint(equalToConstant: 50),
            signButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

        ])

        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .customBackgroundColor.withAlphaComponent(1)
        scrollContentView.addSubview(overlay)

        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: signButton.topAnchor, constant: -10),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc func signInButtonTapped(_: UIButton) {
        let message = "Вы уверены, что хотите \(signButton.titleLabel?.text?.lowercaseFirstLetter() ?? "")?"
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            self?.presenter?.signToEvent()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        self.present(alert, animated: true)
    }
}

extension String {
    func lowercaseFirstLetter() -> String {
        self.prefix(1).lowercased() + self.dropFirst()
    }
}

extension EventDescriptionViewController: PresenterToViewEventDescriptionProtocol {
    func updateEventInfo(_ event: EventEntity) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        nameLabel.text = event.wrappedTitle
        dateLabel.text = "Начало - \(dateFormatter.string(from: event.wrappedTimeStart))\nКонец - \(dateFormatter.string(from: event.wrappedTimeEnd))"
        specificationTextView.text = event.specification
        peopleLabel.text = "\(event.wrappedCurrentAmountOfTickets)/\(event.wrappedMaxCount)"
        addressLabel.text = event.address
    }

    func updateSetButton(with string: String, isEnabled: Bool = true, with color: UIColor) {
        signButton.setTitle(string, for: .normal)
        signButton.isEnabled = isEnabled
        signButton.backgroundColor = color
    }
}
