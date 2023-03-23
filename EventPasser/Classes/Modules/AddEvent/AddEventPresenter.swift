//
//  AddEventPresenter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.11.2022.
//
//

import UIKit

class AddEventPresenter: NSObject, ViewToPresenterAddEventProtocol {
    // MARK: Properties

    weak var view: PresenterToViewAddEventProtocol?
    var interactor: PresenterToInteractorAddEventProtocol?
    var router: PresenterToRouterAddEventProtocol?

    func saveEventInfo(name: String, address: String, maxGuestsCount: Int, specification: String, timeEnd: Date, timeStart: Date, login: String?, password: String?, confirmPassword: String?, image: UIImage?) {
        interactor?.saveEvent(
            name: name,
            address: address,
            maxGuestsCount: maxGuestsCount,
            specification: specification,
            timeEnd: timeEnd,
            timeStart: timeStart,
            login: login,
            password: password,
            confirmPassword: confirmPassword,
            image: image
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

extension AddEventPresenter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func startImagePicker() {
        router?.openImagePicker(on: view!, delegate: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            router?.presentErrorAlert(on: view!, title: "Ошибка", message: "Фото не найдено, попробуйте еще раз", handler: nil)
            return
        }
        
        view?.updateChosenImage(with: image)
    }
}
