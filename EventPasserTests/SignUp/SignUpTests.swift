//
//  SignUpTests.swift
//  EventPasserTests
//
//  Created by Arseniy Matus on 21.12.2022.
//

import XCTest

@testable
import EventPasser

final class SignUpTests: XCTestCase {

    var interactor = SignUpInteractor()
    var presenter = SignUpMockPresenter()
    
    override func setUpWithError() throws {
        interactor.presenter = presenter
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testValidEmail() {
        interactor.validateEmail("arsmatus@list.ru")
        XCTAssertTrue(presenter.isEmailValid)
    }
    
    
    func testWrongEmail1() {
        interactor.validateEmail("arsmatus@listru")
        XCTAssertFalse(presenter.isEmailValid)
    }
    
    func testWrongEmail2() {
        interactor.validateEmail("arsmatus@list..ru")
        XCTAssertFalse(presenter.isEmailValid)
    }
    
    func testWrongEmail3() {
        interactor.validateEmail("arsmatus@@list.ru")
        XCTAssertFalse(presenter.isEmailValid)
    }
    
    func testWrongEmail4() {
        interactor.validateEmail("arsmail.ru")
        XCTAssertFalse(presenter.isEmailValid)
    }
    
    func testEmptyEmail() {
        interactor.validateEmail("")
        XCTAssertFalse(presenter.isEmailValid)
    }
    
    func testValidPassword1() {
        interactor.validatePassword("asdASD123456")
        XCTAssertTrue(presenter.isPasswordValid)
    }
    
    func testValidPassword2() {
        interactor.validatePassword("asdASD_+?.,\\|~[]{}")
        XCTAssertTrue(presenter.isPasswordValid)
    }
    
    func testValidPassword3() {
        interactor.validatePassword("asdASD!@#$%^&*()")
        XCTAssertTrue(presenter.isPasswordValid)
    }
    
    func testWrongPassword1() {
        interactor.validatePassword("1234567")
        XCTAssertFalse(presenter.isPasswordValid)
    }
    
    func testWrongPassword2() {
        interactor.validatePassword(String(Array(repeating: "a", count: 65)))
        XCTAssertFalse(presenter.isPasswordValid)
    }
    
    func testEmptyPassword() {
        interactor.validatePassword("")
        XCTAssertFalse(presenter.isPasswordValid)
    }
    
    func testValidConfirmPassword() {
        interactor.validateConfirmPassword("1234578", "1234578")
        XCTAssertTrue(presenter.isConfirmPasswordValid)
    }
    
    func testWrongConfirmPassword() {
        interactor.validateConfirmPassword("1234578", "12345")
        XCTAssertFalse(presenter.isConfirmPasswordValid)
    }

}
