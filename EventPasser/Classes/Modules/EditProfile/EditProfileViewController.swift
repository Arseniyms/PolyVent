//
//  EditProfileViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 05.11.2022.
//
//

import UIKit

class EditProfileViewController: ScrollableViewController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setupScrollView()
        setupScrollContentView()
        setupUI()
        updateSaveItem()
        presenter?.viewDidLoad()
    }

    // MARK: - Properties

    var isEmailValid = false
    var isNameValid = false
    var isLastnameValid = false
    var isAgeValid = false

    var presenter: ViewToPresenterEditProfileProtocol?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10

        return stackView
    }()

    private lazy var emailTextField: UITextField = {
        let textField = self.getInfoTextField()
        textField.tag = 1
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.setBorderStyle(autocorrectionType: .no, autocapitalizationType: .none)
        textField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)

        return textField
    }()

    @objc func emailTextFieldDidChange(_ textField: UITextField) {
        self.presenter?.emailDidChange(textField.text ?? "")
        textField.textColor = self.isEmailValid ? .dynamic(light: .black, dark: .white) : .red
    }

    private lazy var nameTextField: UITextField = {
        let textField = self.getInfoTextField()
        textField.tag = 2
        textField.textContentType = .givenName
        textField.setBorderStyle()
        textField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)

        return textField
    }()

    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        self.presenter?.nameDidChange(textField.text ?? "")
        textField.textColor = self.isNameValid ? .dynamic(light: .black, dark: .white) : .red
    }

    private lazy var lastNameTextField: UITextField = {
        let textField = self.getInfoTextField()
        textField.tag = 3
        textField.textContentType = .familyName
        textField.setBorderStyle()
        textField.addTarget(self, action: #selector(lastNameTextFieldDidChange), for: .editingChanged)

        return textField
    }()

    @objc func lastNameTextFieldDidChange(_ textField: UITextField) {
        self.presenter?.lastNameDidChange(textField.text ?? "")
        textField.textColor = self.isLastnameValid ? .dynamic(light: .black, dark: .white) : .red
    }

    private lazy var ageTextField: UITextField = {
        let textField = self.getInfoTextField()
        textField.tag = 4
        textField.setBorderStyle()
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(ageTextFieldDidChange), for: .editingChanged)

        return textField
    }()

    @objc func ageTextFieldDidChange(_ textField: UITextField) {
        self.presenter?.ageDidChange(textField.text ?? "")
        textField.textColor = self.isAgeValid ? .dynamic(light: .black, dark: .white) : .red
    }
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .buttonColor
        switcher.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        return switcher
    } ()
    
    private lazy var groupLabel: UILabel = {
        return self.getInfoLabel("Группа")
    } ()
    
    @objc func switchChanged(switcher: UISwitch) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .fade
        groupLabel.layer.add(transition, forKey: "imageReveal")
        groupTextField.layer.add(transition, forKey: "imageReveal")
        
        updateGroupPicker(isShown: switcher.isOn)
    }
    
    private lazy var switcherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(self.getInfoLabel("Вы cтудент?"))
        stackView.addArrangedSubview(switcher)
        
        return stackView
    } ()
    
    private lazy var groupPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = presenter
        picker.dataSource = presenter
        return picker
    } ()
    
    private lazy var groupTextField: UITextField = {
        let textField = self.getInfoTextField()
        textField.tag = 5
        textField.setBorderStyle()
        textField.inputView = groupPicker
        
        return textField
    } ()

    // MARK: - Functions

    func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(exitButtonTapped))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self,
                                                            action: #selector(saveButtonTapped))
    }

    @objc func exitButtonTapped(_: UIButton) {
        self.presenter?.exit()
    }

    @objc func saveButtonTapped(_: UIBarButtonItem) {
        self.presenter?.save(email: self.emailTextField.text,
                             name: self.nameTextField.text,
                             lastname: self.lastNameTextField.text,
                             age: self.ageTextField.text,
                             group: self.groupTextField.text
        )
    }

    func setupScrollContentView() {
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -60),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        self.navigationController?.navigationBar.tintColor = .buttonColor

    }

    func setupUI() {
        view.backgroundColor = .customBackgroundColor

        stackView.addArrangedSubview(self.getInfoLabel("Почта"))
        stackView.addArrangedSubview(emailTextField)

        stackView.addArrangedSubview(self.getInfoLabel("Имя"))
        stackView.addArrangedSubview(nameTextField)

        stackView.addArrangedSubview(self.getInfoLabel("Фамилия"))
        stackView.addArrangedSubview(lastNameTextField)

        stackView.addArrangedSubview(self.getInfoLabel("Возраст"))
        stackView.addArrangedSubview(ageTextField)
        
        stackView.addArrangedSubview(switcherStackView)
    }

    private func updateSaveItem() {
        navigationItem.rightBarButtonItem?.isEnabled = isEmailValid && isNameValid && isLastnameValid && isAgeValid
    }
    
    private func updateGroupPicker(isShown: Bool) {
        if isShown {
            self.stackView.addArrangedSubview(self.groupLabel)
            self.stackView.addArrangedSubview(self.groupTextField)
        } else {
            self.groupLabel.removeFromSuperview()
            self.groupTextField.removeFromSuperview()
            groupTextField.text = ""
        }
    }
    
}

extension EditProfileViewController: PresenterToViewEditProfileProtocol {
    func updateEmailValidation(isEmailValid: Bool) {
        self.isEmailValid = isEmailValid
        updateSaveItem()
    }

    func updateNameValidation(isNameValid: Bool) {
        self.isNameValid = isNameValid
        updateSaveItem()
    }

    func updateLastNameValidation(isLastNameValid: Bool) {
        self.isLastnameValid = isLastNameValid
        updateSaveItem()
    }

    func updateAgeValidation(isAgeValid: Bool) {
        self.isAgeValid = isAgeValid
        updateSaveItem()
    }

    func updateUserInfo(_ user: UserEntity) {
        self.emailTextField.text = user.wrappedEmail
        
        self.emailTextField.placeholder = user.wrappedEmail
        self.nameTextField.placeholder = user.wrappedName
        self.lastNameTextField.placeholder = user.wrappedLastName
        self.ageTextField.placeholder = "Введите возраст"
        self.groupTextField.text = user.group
        self.switcher.setOn(!user.is_teacher, animated: true)
        
        if let _ = user.first_name, let _ = user.last_name {
            self.nameTextField.text = user.wrappedName
            self.lastNameTextField.text = user.wrappedLastName
            self.ageTextField.text = "\(user.wrappedAge)"
            
            presenter?.nameDidChange(user.wrappedName)
            presenter?.lastNameDidChange(user.wrappedLastName)
            presenter?.ageDidChange("\(user.wrappedAge)")
        }

        presenter?.emailDidChange(user.wrappedEmail)
        self.updateGroupPicker(isShown: self.switcher.isOn)

    }
    
    func updateSelectedGroup(with group: String) {
        groupTextField.text = group
    }

    
}
