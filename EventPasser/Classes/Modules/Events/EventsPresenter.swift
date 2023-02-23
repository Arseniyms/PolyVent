//
//  EventsPresenter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//
//

import UIKit

class EventsPresenter: NSObject, ViewToPresenterEventsProtocol {
    // MARK: Properties

    weak var view: PresenterToViewEventsProtocol?
    var interactor: PresenterToInteractorEventsProtocol?
    var router: PresenterToRouterEventsProtocol?

    func viewDidLoad() {
        self.interactor?.getNavigationTitle()
        self.interactor?.loadEventsFromNetwork(with: nil)
    }

    func viewWillAppear() {
        self.interactor?.loadEventsFromCoreData(with: nil)
        self.reloadDataInTable()
    }

    func refresh(with searchInfo: String?) {
        self.interactor?.loadEventsFromNetwork(with: searchInfo)
    }

    func goToEventDescription(with event: EventEntity) {
        self.router?.presentEventDescription(on: self.view!, with: event)
    }

    func goToAddEvent() {
        router?.presentAddEvent(on: view!)
    }

    func goToLoginEvent() {
        router?.pushLoginEvent(on: view!)
    }
}

extension EventsPresenter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        interactor?.numberOfRowsInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.eventCellIdentifier, for: indexPath) as? EventTableViewCell
        guard let event = interactor?.getEvent(at: indexPath.row) else {
            return EventTableViewCell()
        }
        guard let user = LoginService.shared.getLoggedUser() else {
            return EventTableViewCell()
        }
        let isSet = DataService.shared.isUserAlreadySetToEvent(userId: user, eventId: event.wrappedId)

        cell?.setCell(with: event, isSet: isSet)

        return cell ?? EventTableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = interactor?.getEvent(at: indexPath.row) {
            goToEventDescription(with: event)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        // для гладкого скролла
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.05, animations: {
            cell.alpha = 1
        })
    }

    @available(iOS 13.0, *)
    func tableView(_: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point _: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: indexPath.row as NSCopying, previewProvider: {
            if let event = self.interactor?.getEvent(at: indexPath.row) {
                return self.router?.getEventPreview(of: event)
            }
            return nil
        }, actionProvider: nil)
    }

    @available(iOS 13.0, *)
    func tableView(_: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let index = configuration.identifier as? NSNumber else { return }

        animator.addCompletion {
            if let event = self.interactor?.getEvent(at: Int(truncating: index)) {
                DispatchQueue.main.async {
                    self.goToEventDescription(with: event)
                }
            }
        }
    }
}

extension EventsPresenter: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        if !(searchBar.text?.isEmpty ?? false) {
            interactor?.loadEventsFromCoreData(with: searchBar.text)
            reloadDataInTable()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty ?? false) {
            refresh(with: nil)
        }
        if #available(iOS 13.0, *) {
            Vibration.light.vibrate()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            refresh(with: nil)
        }
    }
}

extension EventsPresenter: InteractorToPresenterEventsProtocol {
    func fetchNavigationTitle(_ title: String) {
        view?.setNavigationTitle(title)
    }

    func reloadDataInTable() {
        view?.reloadData()
    }

    func loadEventFromNetworkFailed(with error: Error) {
        router?.presentErrorAlert(on: view!, title: "Ошибка сети", message: error.localizedDescription)
        view?.stopRefreshing()
    }
}
