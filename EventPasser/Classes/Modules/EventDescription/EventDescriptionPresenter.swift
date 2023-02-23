//
//  EventDescriptionPresenter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 19.11.2022.
//  
//

import UIKit

class EventDescriptionPresenter: ViewToPresenterEventDescriptionProtocol {

    // MARK: Properties
    weak var view: PresenterToViewEventDescriptionProtocol?
    var interactor: PresenterToInteractorEventDescriptionProtocol?
    var router: PresenterToRouterEventDescriptionProtocol?
    
    func viewDidLoad() {
        interactor?.loadEvent()
        interactor?.loadIsUserAlreadySet()
        if interactor?.isUserAlreadySet ?? false {
            view?.updateSetButton(with: "Отказаться", isEnabled: true, with: .systemRed)
        } else {
            let isEnabled = interactor?.isEventAvailable() ?? false
            view?.updateSetButton(with: "Записаться", isEnabled: isEnabled, with: .buttonColor)
        }
    }
    
    func signToEvent() {
        interactor?.workWithTicket()
    }
    
    func updatePresentingViewController(_ vc: UIViewController?) {
        let nc = vc as? TabBarViewController
        let pvc = nc?.viewControllers?.compactMap {
            ($0 as? UINavigationController)?.viewControllers.first as? EventsViewController
        }
        pvc?.forEach({
            $0.presenter?.viewWillAppear()
        })
    }
    
    func exit() {
        router?.goBack(view!)
    }
}

extension EventDescriptionPresenter: InteractorToPresenterEventDescriptionProtocol {
    func fetchEventInfo(_ event: EventEntity) {
        view?.updateEventInfo(event)
    }
    
    func setTicketDone() {
        Vibration.success.vibrate()
        exit()
    }
    
    func setTicketWentWrong(with error: Error) {
        Vibration.error.vibrate()
        router?.presentErrorAlert(on: view!, title: "Ошибка", message: error.localizedDescription)
    }
}
