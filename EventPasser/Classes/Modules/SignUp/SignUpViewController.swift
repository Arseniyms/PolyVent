//
//  SignUpViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//
//

import UIKit

class SignUpViewController: ScrollableViewController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(exitButtonTapped))

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        setupScrollView()
        setupScrollContentView()
        setupUI()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
//    }

    @objc func exitButtonTapped(_: UIButton) {
        self.presenter?.exit()
    }

    // MARK: - Properties

    var presenter: ViewToPresenterSignUpProtocol?

    var isEmailValid = false
    var isPassValid = false
    var isConfirmPassValid = false

    var signingUp = false {
        didSet {
            if #available(iOS 15.0, *) {
                signUpButton.setNeedsUpdateConfiguration()
            }
        }
    }

    private lazy var stackView: UIStackView = {
        var stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .fill
        stackview.spacing = 10

        return stackview
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
        self.presenter?.emailDidChange(to: textField.text ?? "")
        textField.textColor = self.isEmailValid ? .dynamic(light: .black, dark: .white) : .red
    }

    private lazy var passTextField: UITextField = {
        let textField = self.getPasswordTextField()
        textField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        textField.tag = 2

        return textField
    }()

    private lazy var confirmPassTextField: UITextField = {
        let textField = self.getPasswordTextField()
        textField.addTarget(self, action: #selector(passwordConfirmTextFieldDidChange), for: .editingChanged)
        textField.tag = 3

        return textField
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.bordered()
            config.buttonSize = .small
            config.cornerStyle = .medium
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .buttonColor
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
                var outgoing = $0
                outgoing.font = UIFont.systemFont(ofSize: 30, weight: .light)
                return outgoing
            }

            button.configuration = config

            button.configurationUpdateHandler = { [weak self] button in
                guard let self else { return }
                var config = button.configuration
                config?.showsActivityIndicator = self.signingUp
                config?.title = self.signingUp ? "Регистрация..." : "Регистрация"
                button.isEnabled = !self.signingUp && self.isPassValid && self.isEmailValid && self.isConfirmPassValid
                button.configuration = config
            }

        } else {
            button.isEnabled = false
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.systemGray, for: .disabled)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
            button.layer.cornerRadius = 10
            button.backgroundColor = UIColor.buttonColor
        }

        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var invalidPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль должен быть больше 8 символов и на английском"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .customBackgroundColor

        return label
    }()

    private lazy var invalidConfirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароли должны совпадать"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .customBackgroundColor

        return label
    }()

    private lazy var scrollContentView: UIView = .init()
    var bottomSignUpButtonConstraint = NSLayoutConstraint()
    // MARK: - Functions
    
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
        
        self.navigationController?.navigationBar.tintColor = .buttonColor
    }


    func setupUI() {
        view.backgroundColor = .customBackgroundColor

        stackView.addArrangedSubview(self.getInfoLabel("Почта"))
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(self.getInfoLabel("Пароль"))
        stackView.addArrangedSubview(passTextField)
        stackView.addArrangedSubview(self.getInfoLabel("Подтвердите пароль"))
        stackView.addArrangedSubview(confirmPassTextField)
        stackView.addArrangedSubview(invalidPasswordLabel)
        stackView.addArrangedSubview(invalidConfirmPasswordLabel)

        stackView.setCustomSpacing(5, after: confirmPassTextField)
        stackView.setCustomSpacing(5, after: invalidPasswordLabel)

        scrollContentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        bottomSignUpButtonConstraint = signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollContentView.centerYAnchor, constant: -20),

            signUpButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            bottomSignUpButtonConstraint
        ])
        
        self.view.layoutIfNeeded()

    }

    @objc internal override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomSignUpButtonConstraint.constant = -height - 20
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc internal override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomSignUpButtonConstraint.constant = -40
            self.view.layoutIfNeeded()
        })
    }

    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        presenter?.passDidChange(to: textField.text ?? "")
        presenter?.confirmPassDidChange(to: confirmPassTextField.text ?? "", password: textField.text ?? "")

        if !isPassValid {
            invalidPasswordLabel.textColor = .systemRed
        } else {
            invalidPasswordLabel.textColor = .customBackgroundColor
        }
        if !isConfirmPassValid, isPassValid {
            invalidConfirmPasswordLabel.textColor = .systemRed
        } else {
            invalidConfirmPasswordLabel.textColor = .customBackgroundColor
        }
    }

    @objc private func passwordConfirmTextFieldDidChange(_ textField: UITextField) {
        presenter?.confirmPassDidChange(to: textField.text ?? "", password: passTextField.text ?? "")
        if !isConfirmPassValid {
            invalidConfirmPasswordLabel.textColor = .systemRed
            invalidPasswordLabel.layoutIfNeeded()
        } else {
            invalidConfirmPasswordLabel.textColor = .customBackgroundColor
        }
    }

    @objc private func signUpButtonPressed(_: UIButton) {
        self.signingUp = true
        presenter?.signUpTapped(email: emailTextField.text ?? "", password: passTextField.text ?? "")
    }

    func updateSignUpButton() {
        signUpButton.isEnabled = isPassValid && isConfirmPassValid && isEmailValid
    }
}

extension SignUpViewController: PresenterToViewSignUpProtocol {
    func updatePasswordValidation(isPassValid: Bool) {
        self.isPassValid = isPassValid
        self.updateSignUpButton()
    }

    func updateConfirmPasswordValidation(isConfirmPassValid: Bool) {
        self.isConfirmPassValid = isConfirmPassValid
        self.updateSignUpButton()
    }

    func updateEmailValidation(isEmailValid: Bool) {
        self.isEmailValid = isEmailValid
        self.updateSignUpButton()
    }
    
    func signUpSuccess() {
        self.signingUp = false
    }
    
    func signUpFailed() {
        self.signingUp = false
    }
}
