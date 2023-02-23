//
//  EventLoginViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 04.12.2022.
//
//

import UIKit

class EventLoginViewController: ScrollableViewController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backButtonTitle = "Назад"

        setupScrollView()
        setupScrollViewConstraints()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.signingIn = false
    }
    
    deinit {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10

        return stackView
    }()

    // MARK: - Properties
    var presenter: ViewToPresenterEventLoginProtocol?
    
    
    private lazy var loginTextField: UITextField = {
        let textField = getInfoTextField()
        textField.tag = 1
        textField.setBorderStyle(autocorrectionType: .no, autocapitalizationType: .none)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return textField
    }()

    private lazy var passTextField: UITextField = {
        let textField = getPasswordTextField()
        textField.tag = 2
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return textField
    }()

    var signingIn = false {
        didSet {
            if #available(iOS 15.0, *) {
                signInButton.setNeedsUpdateConfiguration()
            }
        }
    }
    
    private var isPassValid: Bool {
        passTextField.text?.isEmpty ?? true
    }
    
    private var isLoginValid: Bool {
        loginTextField.text?.isEmpty ?? true
    }

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
                button.isEnabled = !self.signingIn && (!self.isPassValid || !self.isLoginValid)
                button.configuration = config
            }
        } else {
            button.tintColor = .white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
            button.layer.cornerRadius = 10
            button.backgroundColor = .buttonColor
            button.isEnabled = false
        }

        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        return button

    }()

    func setupScrollViewConstraints() {
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -60),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    // MARK: - Functions
    
    func setupUI() {
        view.backgroundColor = .customBackgroundColor

        stackView.addArrangedSubview(getInfoLabel("Логин мероприятия"))
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(getInfoLabel("Пароль мероприятия"))
        stackView.addArrangedSubview(passTextField)
        stackView.setCustomSpacing(20, after: passTextField)
        stackView.addArrangedSubview(signInButton)
        
    }
    
    @objc func signInButtonPressed(_: UIButton) {
        self.signingIn = true
        presenter?.signInTapped(login: loginTextField.text ?? "", password: passTextField.text ?? "")
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        signInButton.isEnabled = (!self.isPassValid || !self.isLoginValid)
    }
}

extension EventLoginViewController: PresenterToViewEventLoginProtocol {
    func loginFailed() {
        self.signingIn = false
        passTextField.text = ""
        loginTextField.text = ""
    }
}
