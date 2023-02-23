//
//  EditProfileTests.swift
//  EventPasserTests
//
//  Created by Arseniy Matus on 21.12.2022.
//

import XCTest

@testable
import EventPasser

final class EditProfileTests: XCTestCase {
    
    var interactor = EditProfileInteractor()
    var presenter = EditProfileMockPresenter()
    
    override func setUpWithError() throws {
        interactor.presenter = presenter
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testValidEmail1() {
        interactor.validateEmail("kdmqw@dqwsss.cdwww")
        XCTAssertTrue(presenter.isEmailValid)
    }
    
    func testValidEmail2() {
        interactor.validateEmail("mail@ya-1.ya-2.ru")
        XCTAssertTrue(presenter.isEmailValid)
    }
    
    func testWrongEmail1() {
        interactor.validateEmail("dmkfkm2mr1323")
        XCTAssertFalse(presenter.isEmailValid)
    }
    
    func testWrongEmail2() {
        interactor.validateEmail("notmail@ya-ru")
        XCTAssertFalse(presenter.isEmailValid)
    }
    
    func testWrongEmail3() {
        interactor.validateEmail("mail@ya-1@ya-2.ru")
        XCTAssertFalse(presenter.isEmailValid)
    }
    
    func testValidName1() {
        interactor.validateName("Arseniy")
        XCTAssertTrue(presenter.isNameValid)
    }
    
    func testValidName2() {
        interactor.validateName("Арсений")
        XCTAssertTrue(presenter.isNameValid)
    }
    
    func testWrongName1() {
        interactor.validateName("Arseniy39")
        XCTAssertFalse(presenter.isNameValid)
    }
    
    func testWrongName2() {
        interactor.validateName("")
        XCTAssertFalse(presenter.isNameValid)
    }
    
    func testValidLastName1() {
        interactor.validateName("Matus")
        XCTAssertTrue(presenter.isNameValid)
    }
    
    func testValidLastName2() {
        interactor.validateName("O'Connor")
        XCTAssertTrue(presenter.isNameValid)
    }
    
    func testValidLastName3() {
        interactor.validateName("Матус")
        XCTAssertTrue(presenter.isNameValid)
    }
    
    func testWrongLastName1() {
        interactor.validateName("")
        XCTAssertFalse(presenter.isNameValid)
    }
    
    func testWrongLastName2() {
        interactor.validateName("Матус39")
        XCTAssertFalse(presenter.isNameValid)
    }
    
    
    func testValidAge() {
        interactor.validateAge("21")
        XCTAssertTrue(presenter.isAgeValid)
    }
    
    func testWrongAge() {
        interactor.validateAge("-1")
        XCTAssertFalse(presenter.isAgeValid)
    }
    
    func testEmptyAge() {
        interactor.validateAge("")
        XCTAssertFalse(presenter.isAgeValid)
    }
    
    func testWrongaStringAge() {
        interactor.validateAge("twenty-one")
        XCTAssertFalse(presenter.isAgeValid)
    }
    
}
