//
//  EventSecurityRouter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 04.12.2022.
//
//

import UIKit

class EventSecurityRouter: PresenterToRouterEventSecurityProtocol {
    // MARK: Static methods

    static func createModule(event: EventEntity) -> UIViewController {
        let viewController = EventSecurityViewController()

        let presenter: ViewToPresenterEventSecurityProtocol & InteractorToPresenterEventSecurityProtocol = EventSecurityPresenter()

        viewController.presenter = presenter
        viewController.presenter?.router = EventSecurityRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = EventSecurityInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.setEvent(event)

        return viewController
    }

    func presentErrorAlert(on view: PresenterToViewEventSecurityProtocol, title: String, message: String, noPassHandler: ((UIAlertAction) -> Void)? = nil) {
        let vc = view as? EventSecurityViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: noPassHandler))
        vc?.present(alert, animated: true)
    }

    func presentUserAlert(on view: PresenterToViewEventSecurityProtocol, user: UserEntity, isOkay: Bool, passHandler: ((UIAlertAction) -> Void)? = nil, noPassHandler: ((UIAlertAction) -> ())? = nil) {
        let vc = view as? EventSecurityViewController

        let message = "Пользователь\(isOkay ? " " : " НЕ ")записан на мероприятие"
        let attributedString = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            .font: UIFont.preferredFont(forTextStyle: .callout)
        ])
        
        let alert = UIAlertController(title: user.wrappedFullName, message: message, preferredStyle: .alert)

        if isOkay {
            alert.addAction(UIAlertAction(title: "Пропустить", style: .default, handler: passHandler))
            alert.addAction(UIAlertAction(title: "Не пропускать", style: .cancel, handler: noPassHandler))
        } else {
            alert.setValue(attributedString, forKey: "attributedMessage")
            alert.view.tintColor = .red
            alert.addAction(UIAlertAction(title: "Не пропускать", style: .cancel, handler: noPassHandler))
        }

        vc?.present(alert, animated: true)
    }
}
