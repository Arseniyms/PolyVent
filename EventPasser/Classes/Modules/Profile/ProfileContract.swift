//
//  ProfileContract.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//  
//

import UIKit


// MARK: View Output (Presenter -> View)
protocol PresenterToViewProfileProtocol: AnyObject {
    func updateUserInfo(_ user: UserEntity)
    
    func updateQrImage(with image: UIImage)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterProfileProtocol: AnyObject {
    
    var view: PresenterToViewProfileProtocol? { get set }
    var interactor: PresenterToInteractorProfileProtocol? { get set }
    var router: PresenterToRouterProfileProtocol? { get set }
    
    func goToSignIn()
    func goToEditProfile()

    
    func viewDidLoad()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorProfileProtocol: AnyObject {
    
    var presenter: InteractorToPresenterProfileProtocol? { get set }
    
    func getUser()
    func deleteLoggedUser()
    func generateQRCode(with string: String)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterProfileProtocol: AnyObject {
    func loggedUserError()
    func fetchUserInfo(_ user: UserEntity)
    
    func fetchQrImageSuccess(with image: UIImage)
    func fetchQrImageFailure()
    
    func loadNetworkError()
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterProfileProtocol: AnyObject {    
    func switchToSignIn(on view: PresenterToViewProfileProtocol)
    func presentEditProfile(on view: PresenterToViewProfileProtocol)
    
    func presentNetworkError(on view: PresenterToViewProfileProtocol, title: String, message: String)
}
