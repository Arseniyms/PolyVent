//
//  ProfileInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//
//

import CoreData
import CoreImage.CIFilterBuiltins
import Firebase
import UIKit

class ProfileInteractor: PresenterToInteractorProfileProtocol {
    // MARK: Properties

    weak var presenter: InteractorToPresenterProfileProtocol?

    func getUser() {
        guard let loggedUser = Auth.auth().currentUser else {
            self.presenter?.loggedUserError()
            return
        }
        let predicate = NSPredicate(format: "id = %@", loggedUser.uid)

        FirebaseService.shared.loadUsersToCoreData { result in
            switch result {
            case .success:
                let user = DataService.shared.getUser(predicate: predicate)
                user?.email = loggedUser.email
                if let user {
                    self.presenter?.fetchUserInfo(user)
                    self.generateQRCode(with: user.wrappedStringId)
                } else {
                    self.presenter?.fetchQrImageFailure()
                }
                do {
                    try DataService.shared.saveContext()
                } catch {
                    self.presenter?.loadNetworkError()
                }

            case .failure:
                let user = DataService.shared.getUser(predicate: predicate)
                if let user {
                    user.email = loggedUser.email
                    self.generateQRCode(with: loggedUser.uid)
                    self.presenter?.fetchUserInfo(user)
                } else {
                    self.presenter?.loadNetworkError()
                }
            }
        }
    }

    func deleteLoggedUser() {
        do {
            try Auth.auth().signOut()
        } catch {
            presenter?.loadNetworkError()
        }
    }

    func generateQRCode(with string: String) {
        DispatchQueue.main.async { [weak self] in
            var qrImage = UIImage()
            qrImage = string.qrCode()
            self?.presenter?.fetchQrImageSuccess(with: qrImage)
        }
    }
}

extension String {
    func qrCode() -> UIImage {
        let context = CIContext()
        var qrImage = UIImage(systemName: "xmark.circle") ?? UIImage()
        let data = Data(self.utf8)
        let filter = CIFilter.qrCodeGenerator()

        var osTheme: UIUserInterfaceStyle { return UIScreen.main.traitCollection.userInterfaceStyle }
        filter.setValue(data, forKey: "inputMessage")

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let _ = context.createCGImage(
                outputImage,
                from: outputImage.extent
            ) {
                let maskFilter = CIFilter.blendWithMask()
                maskFilter.maskImage = outputImage.applyingFilter("CIColorInvert")

                maskFilter.inputImage = CIImage(color: .white)

                let darkCIImage = maskFilter.outputImage!
                maskFilter.inputImage = CIImage(color: .black)

                let lightCIImage = maskFilter.outputImage!

                let darkImage = context.createCGImage(darkCIImage, from: darkCIImage.extent).map(UIImage.init)!
                let lightImage = context.createCGImage(lightCIImage, from: lightCIImage.extent).map(UIImage.init)!

                qrImage = osTheme == .light ? lightImage : darkImage
            }
        }
        return qrImage
    }
}
