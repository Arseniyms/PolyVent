//
//  AddEventTests.swift
//  EventPasserTests
//
//  Created by Arseniy Matus on 21.12.2022.
//

import XCTest

@testable
import EventPasser

final class AddEventTests: XCTestCase {
    var interactor = AddEventInteractor()

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidInfo() {
        XCTAssertNoThrow(try interactor.checkEventInfo(name: "Новый год", address: "Проспект Мира 1", maxGuestsCount: 30, login: "newyear", password: "12345678", confirmPassword: "12345678"))
    }

    func testWrongInfo() {
        let longInfo = String(Array(repeating: "a", count: 151))
        
        let tests: [(name: String, address: String, count: Int, login: String, pass: String, confirmPass: String, error: EventAuthorizationError?)] = [
            ("", "Проспект мира 1", 30, "newyear", "12345678", "12345678", EventAuthorizationError.invalidName),
            (longInfo, "Проспект мира 1", 30, "newyear", "12345678", "12345678", EventAuthorizationError.invalidName),
            
            ("ValidName", "", 30, "newyear", "12345678", "12345678", EventAuthorizationError.invalidAddress),
            ("ValidName", longInfo, 30, "newyear", "12345678", "12345678", EventAuthorizationError.invalidAddress),
            
            ("ValidName", "Проспект Мира", -1, "newyear", "12345678", "12345678", EventAuthorizationError.invalidGuestCount),
            ("ValidName", "Проспект Мира", 10001, "newyear", "12345678", "12345678", EventAuthorizationError.invalidGuestCount),
            
            ("ValidName", "Проспект Мира", 30, "newyear", "1234567", "12345678", EventAuthorizationError.invalidPassword),
            ("ValidName", "Проспект Мира", 30, "newyear", "", "12345678", EventAuthorizationError.invalidPassword),
            ("ValidName", "Проспект Мира", 30, "newyear", longInfo, "12345678", EventAuthorizationError.invalidPassword),

            ("ValidName", "Проспект Мира", 30, "newyear", "12345678", "123456789", EventAuthorizationError.invalidConfirmPassword),
            ("ValidName", "Проспект Мира", 30, "newyear", "12345678", "", EventAuthorizationError.invalidConfirmPassword),
        ]

        for test in tests {
            XCTAssertThrowsError(try interactor.checkEventInfo(name: test.name,
                                                               address: test.address,
                                                               maxGuestsCount: test.count,
                                                               login: test.login,
                                                               password: test.pass,
                                                               confirmPassword: test.confirmPass)) { error in
                XCTAssertEqual(error as? EventAuthorizationError, test.error)
            }
        }
    }
}
