//
//  EventSecurityPresenter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 04.12.2022.
//
//

import AVFoundation
import UIKit

class EventSecurityPresenter: NSObject, ViewToPresenterEventSecurityProtocol {
    var captureSession: AVCaptureSession!

    // MARK: Properties

    weak var view: PresenterToViewEventSecurityProtocol?
    var interactor: PresenterToInteractorEventSecurityProtocol?
    var router: PresenterToRouterEventSecurityProtocol?

    func refresh() {
        interactor?.updateEvent()
    }
    
    func setEvent(_ event: EventEntity) {
        interactor?.event = event
    }

    func viewDidLoad() {
        interactor?.loadTickets()
        interactor?.getTitle()
        prepareSession()
    }

    func startRunning() {
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }

    func stopRunning() {
        if captureSession?.isRunning == true {
            self.captureSession.stopRunning()
        }
    }

    private func prepareSession() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
    }

    private func failed() {
        router?.presentErrorAlert(on: view!, title: "Сканирование невозможно", message: "Ваше устройство не поддерживает сканирование QR-кодов. Пожалуйста, попробуйте заново или другое устройство", noPassHandler: nil)

        captureSession = nil
    }

    func metadataOutput(_: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from _: AVCaptureConnection) {
        stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            interactor?.foundCode(code: stringValue)
        }
    }
}

extension EventSecurityPresenter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        interactor?.numberOfRowsInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userCellIdentifier, for: indexPath) as? UserTableViewCell
        guard let user = interactor?.getUser(at: indexPath.row) else { return UserTableViewCell() }
        guard let event = interactor?.event else { return UserTableViewCell() }
        let isInside = DataService.shared.isUserInside(user, in: event)
        cell?.setCell(with: user, isUserInside: isInside)

        return cell ?? UserTableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let user = interactor?.getUser(at: indexPath.row) {
            validUserFound(user: user, isOkay: true)
        }
    }
}

extension EventSecurityPresenter: InteractorToPresenterEventSecurityProtocol {
    func userToPass(_ user: UserEntity, isInside: Bool, isOkay: Bool) {
        interactor?.userPass(user, isInside: isInside, isOkay: isOkay)
        self.startRunning()
    }

    func fetchTitle(_ title: String) {
        view?.updateTitle(with: title)
    }

    func validUserFound(user: UserEntity, isOkay: Bool) {
        router?.presentUserAlert(on: view!, user: user, isOkay: isOkay, passHandler: { [weak self] _ in
            self?.userToPass(user, isInside: true, isOkay: isOkay)
        }, noPassHandler: { [weak self] _ in
            self?.userToPass(user, isInside: false, isOkay: isOkay)
        })

    }

    func userCodeError(message: String) {
        router?.presentErrorAlert(on: view!, title: "Ошибка", message: message) { _ in
            self.startRunning()
        }
    }

    func reloadDataInTableView() {
        view?.reloadTableView()
    }
}
