//
//  AddEventViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.11.2022.
//
//

import UIKit

class AddEventViewController: ScrollableViewController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setupScrollView()
        setupScrollContentView()

        presenter?.viewDidLoad()
        setupUI()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties

    var presenter: ViewToPresenterAddEventProtocol?

    private lazy var scrollContentView: UIView = .init()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5

        return stackView
    }()

    private lazy var warningTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .caption2)
        textView.alpha = 0.6
        textView.isEditable = false
        textView.isSelectable = false
        textView.textAlignment = .center
        textView.isScrollEnabled = false

        textView.text = "У вас всего одна попытка создания мероприятия. В будущем у вас не будет возможности что-то изменить."
        return textView
    }()

    private lazy var loginTextField: UITextField = {
        let textField = self.getInfoTextField()
        textField.tag = 1
        textField.textContentType = .username
        textField.setBorderStyle(autocorrectionType: .no, autocapitalizationType: .none)

        return textField
    }()

    private lazy var passTextField: UITextField = {
        let textField = self.getPasswordTextField()
        textField.tag = 2

        return textField
    }()

    private lazy var confirmPassTextField: UITextField = {
        let textField = self.getPasswordTextField()
        textField.tag = 3

        return textField
    }()

    private lazy var titleTextField: UITextField = {
        let textField = self.getInfoTextField()
        textField.tag = 4
        textField.setBorderStyle()

        return textField
    }()

    private lazy var addressTextField: UITextField = {
        let textField = self.getInfoTextField()
        textField.tag = 5
        textField.textContentType = .fullStreetAddress
        textField.setBorderStyle()

        return textField
    }()

    private lazy var startDatePicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.minimumDate = Date()
        datepicker.datePickerMode = .dateAndTime
        datepicker.minuteInterval = 10
        datepicker.isHidden = false
        datepicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)

        return datepicker
    }()

    private lazy var endDatePicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.minimumDate = Date()
        datepicker.datePickerMode = .dateAndTime
        datepicker.minuteInterval = 10
        datepicker.isHidden = false

        return datepicker
    }()

    private lazy var maxCountTextField: UITextField = {
        let textField = self.getInfoTextField()
        textField.tag = 6
        textField.keyboardType = .numberPad // .numbersAndPunctuation to silence warning
        textField.textContentType = .oneTimeCode
        textField.setBorderStyle()

        return textField
    }()

    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить фото", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.backgroundColor = .buttonColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        button.makeLivePressing()

        return button
    }()

    private lazy var addedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let interaction = UIContextMenuInteraction(delegate: self)
        imageView.addInteraction(interaction)

        return imageView
    }()

    private lazy var addImageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addImageButton])
        stackView.axis = .horizontal
        stackView.spacing = 5

        return stackView
    }()

    private lazy var specificationTextView: UITextView = {
        let textView = UITextView()
        textView.tag = 7
        textView.font = .systemFont(ofSize: 20, weight: .light)
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.cornerRadius = 4
        textView.backgroundColor = .gray.withAlphaComponent(0.1)
        textView.textContainerInset.top = 6
        textView.textContainerInset.bottom = 6

        return textView
    }()

    // MARK: Functions

    func setupNavigationItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
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

        stackView.addArrangedSubview(warningTextView)
        stackView.addArrangedSubview(self.getInfoLabel("Логин"))
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(self.getInfoLabel("Пароль"))
        stackView.addArrangedSubview(passTextField)
        stackView.addArrangedSubview(self.getInfoLabel("Подтвердите пароль"))
        stackView.addArrangedSubview(confirmPassTextField)
        stackView.addArrangedSubview(self.getInfoLabel("Название"))
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(self.getInfoLabel("Адрес"))
        stackView.addArrangedSubview(addressTextField)
        stackView.addArrangedSubview(self.getInfoLabel("Время начала"))
        stackView.addArrangedSubview(startDatePicker)
        stackView.addArrangedSubview(self.getInfoLabel("Время конца"))
        stackView.addArrangedSubview(endDatePicker)
        stackView.addArrangedSubview(self.getInfoLabel("Максимальное количество посетителей"))
        stackView.addArrangedSubview(maxCountTextField)
        stackView.setCustomSpacing(10, after: maxCountTextField)
        stackView.addArrangedSubview(addImageStackView)
        stackView.setCustomSpacing(10, after: addImageStackView)
        stackView.addArrangedSubview(self.getInfoLabel("Описание мероприятия"))

        scrollContentView.addSubview(stackView)
        scrollContentView.addSubview(specificationTextView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),

            specificationTextView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            specificationTextView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -60),
            specificationTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            specificationTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),

        ])
    }

    @objc func saveButtonTapped(_: UIBarButtonItem) {
        presenter?.saveEventInfo(
            name: titleTextField.text ?? "",
            address: addressTextField.text ?? "",
            maxGuestsCount: Int(maxCountTextField.text ?? "") ?? 0,
            specification: specificationTextView.text,
            timeEnd: endDatePicker.date,
            timeStart: startDatePicker.date,
            login: loginTextField.text,
            password: passTextField.text,
            confirmPassword: confirmPassTextField.text,
            image: addedImageView.image
        )
    }

    @objc func startDatePickerValueChanged(_: UIDatePicker) {
        endDatePicker.minimumDate = startDatePicker.date
    }

    @objc func addPhotoButtonTapped(_: UIButton) {
        presenter?.startImagePicker()
    }
}

extension AddEventViewController: PresenterToViewAddEventProtocol {
    func updateChosenImage(with image: UIImage) {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.addImageStackView.insertArrangedSubview(self.addedImageView, at: 0)
            self.addImageStackView.layoutIfNeeded()
        } completion: { _ in
            self.addedImageView.image = image
        }
    }

    func removeChosenImage() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.addedImageView.removeFromSuperview()
            self.addedImageView.image = nil
            self.addImageStackView.layoutIfNeeded()
        }
    }
}

extension AddEventViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_: UIContextMenuInteraction, configurationForMenuAtLocation _: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            self.makeContextMenu()
        })
    }

    func makeContextMenu() -> UIMenu {
        let edit = UIAction(title: "Изменить", image: UIImage(systemName: "photo.on.rectangle")) { _ in
            self.presenter?.startImagePicker()
        }

        let delete = UIAction(
            title: "Удалить",
            image: UIImage(systemName: "xmark.circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        ) { _ in
            self.removeChosenImage()
        }

        return UIMenu(title: "", children: [edit, delete])
    }
}
