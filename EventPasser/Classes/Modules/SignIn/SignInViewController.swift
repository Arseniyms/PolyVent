//
//  SignInViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//
//

import UIKit

class SignInViewController: ScrollableViewController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupScrollView()
        setupScrollContentView()
        setupUI()
        
        presenter?.emailDidChange(to: "")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        qrImageView.startShimmering()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        qrImageView.stopShimmering()
    }

    // MARK: - Properties

    var presenter: ViewToPresenterSignInProtocol?

    private var isEmailValid = false
    private var isPassValid = false

    var signingIn = false {
        didSet {
            if #available(iOS 15.0, *) {
                signInButton.setNeedsUpdateConfiguration()
            }
        }
    }


    private lazy var welcomeLabel: UILabel = {
        var label = UILabel()
        label.text = "Добро\nпожаловать!"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 50, weight: .ultraLight)
        
        return label
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

    private lazy var emailLabel: UILabel = self.getInfoLabel("Почта")

    private lazy var passwordLabel: UILabel = self.getInfoLabel("Пароль")

    private lazy var passwordTextField: UITextField = {
        let textField = self.getPasswordTextField()
        textField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        textField.tag = 2

        return textField
    }()

    private lazy var signInButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Вход", for: .normal)
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
                config?.showsActivityIndicator = self.signingIn
                config?.title = self.signingIn ? "" : "Вход"
                button.isEnabled = !self.signingIn && (self.isPassValid || self.isEmailValid)
                button.configuration = config
            }
        } else {
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.systemGray, for: .disabled)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
            button.layer.cornerRadius = 10
            button.backgroundColor = UIColor.buttonColor
        }

        button.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)

        button.setTitleColor(.dynamic(light: .black, dark: .white), for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)

        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var qrImageView: UIImageView = {
        var imageView = UIImageView()
        let image = UIImage(named: "start")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        imageView.image = image
        imageView.tintColor = .blue

        return imageView
    }()

    private lazy var scrollContentView: UIView = .init()
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
    
    private func setupUI() {
        view.backgroundColor = .customBackgroundColor

        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        qrImageView.translatesAutoresizingMaskIntoConstraints = false

        scrollContentView.addSubview(emailLabel)
        scrollContentView.addSubview(emailTextField)
        scrollContentView.addSubview(welcomeLabel)
        scrollContentView.addSubview(passwordLabel)
        scrollContentView.addSubview(passwordTextField)
        scrollContentView.addSubview(signInButton)
        scrollContentView.addSubview(signUpButton)
        scrollContentView.addSubview(qrImageView)

        NSLayoutConstraint.activate([
            qrImageView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 40),
            qrImageView.widthAnchor.constraint(equalToConstant: 200),
            qrImageView.heightAnchor.constraint(equalToConstant: 200),
            qrImageView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: -19),

            welcomeLabel.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: -5),
            welcomeLabel.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -30),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 150),

            emailLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 30),
            emailLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -30),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -30),

            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 30),

            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -30),

            signInButton.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signInButton.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 30),
            signInButton.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 60),

            signUpButton.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            signUpButton.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -80),
        ])

        UIView.animate(withDuration: 1, delay: 0, options: .transitionFlipFromLeft, animations: {
            self.qrImageView.layoutIfNeeded()
        })

        let transition = CATransition()
        transition.duration = 1
        transition.type = .push
        self.welcomeLabel.layer.add(transition, forKey: "welcomeReveal")
        self.welcomeLabel.layoutIfNeeded()
    }

    @objc private func signInButtonPressed(_: UIButton) {
        signingIn = true
        presenter?.signInTapped(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }

    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        presenter?.passDidChange(to: textField.text ?? "")
    }

    @objc private func signUpButtonTapped(_: UIButton) {
        presenter?.goToSignUp()
    }

    private func updateSignInButton() {
        signInButton.isEnabled = isPassValid || isEmailValid
    }
}

extension SignInViewController: PresenterToViewSignInProtocol {
    func updatePasswordValidation(isPassValid: Bool) {
        self.isPassValid = isPassValid
        self.updateSignInButton()
    }

    func updateEmailValidation(isEmailValid: Bool) {
        self.isEmailValid = isEmailValid
        self.updateSignInButton()
    }
    
    func signInFailed() {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.signingIn = false
        updateEmailValidation(isEmailValid: false)
        updatePasswordValidation(isPassValid: false)
    }

    
}
