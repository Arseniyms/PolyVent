//
//  AddEventPresenter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.11.2022.
//
//

import UIKit

class AddEventPresenter: ViewToPresenterAddEventProtocol {
    // MARK: Properties

    weak var view: PresenterToViewAddEventProtocol?
    var interactor: PresenterToInteractorAddEventProtocol?
    var router: PresenterToRouterAddEventProtocol?

    func saveEventInfo(name: String, address: String, maxGuestsCount: Int, specification: String, timeEnd: Date, timeStart: Date, login: String?, password: String?, confirmPassword: String?) {
        interactor?.saveEvent(
            name: name,
            address: address,
            maxGuestsCount: maxGuestsCount,
            specification: specification,
            timeEnd: timeEnd,
            timeStart: timeStart,
            login: login,
            password: password,
            confirmPassword: confirmPassword
        )
    }

    func viewDidLoad() {
        DispatchQueue.main.async {
            self.interactor?.isUserStaff()
        }
    }
}

extension AddEventPresenter: InteractorToPresenterAddEventProtocol {
    func saveEventSuccess() {
        router?.popViewController(view!)
    }

    func saveEventFailure(with error: Error, handler: ((UIAlertAction) -> Void)? = nil) {
        router?.presentErrorAlert(on: view!, title: "Ошибка", message: error.localizedDescription, handler: handler)
    }
}
