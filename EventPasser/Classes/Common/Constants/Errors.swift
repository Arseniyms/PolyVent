//
//  Errors.swift
//  EventPasser
//
//  Created by Arseniy Matus on 14.11.2022.
//

import Foundation

enum AuthorizationError: Error {
    case emailAlreadyExist, saveError, invalidEmailOrPassword, idError, unknownError, blankField, userNotStaff
}

extension AuthorizationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emailAlreadyExist:
            return NSLocalizedString("Пользователь с такой почтой уже зарегистрирован.", comment: "")
        case .saveError:
            return NSLocalizedString("Ошибка регистрации. Попробуйте позже.", comment: "")
        case .invalidEmailOrPassword:
            return NSLocalizedString("Неверный пароль или почта, введите заново.", comment: "")
        case .idError:
            return NSLocalizedString("Ошибка изменения. Попробуйте позже.", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка, повторите позже.", comment: "")
        case .blankField:
            return NSLocalizedString("Заполните все поля, введите заново.", comment: "")
        case .userNotStaff:
            return NSLocalizedString("Вы не можете добавлять собственные меропрития. Пожалуйста, обратитесь в тех.поддержку", comment: "")
        }
    }
}

enum KeychainError: Error {
    case itemNotFound, invalidItemFormat, unhandledError(status: OSStatus)
}

enum EventAuthorizationError: Error {
    case eventAlreadyExist, saveError, invalidLogin, invalidName, invalidAddress, invalidGuestCount, invalidPassword, invalidAuthorization, invalidConfirmPassword
}

extension EventAuthorizationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .eventAlreadyExist:
            return NSLocalizedString("Мероприятие с таким логином уже зарегистрировано", comment: "")
        case .saveError:
            return NSLocalizedString("Ошибка регистрации. Попробуйте позже", comment: "")
        case .invalidLogin:
            return NSLocalizedString("Логин должен быть не больше \(Constants.maxInfoLenght) символов и не пустой", comment: "")
        case .invalidName:
            return NSLocalizedString("Название должно быть не больше \(Constants.maxInfoLenght) символов и не пустое", comment: "")
        case .invalidAddress:
            return NSLocalizedString("Адрес должен быть не больше \(Constants.maxInfoLenght) символов и не пустой", comment: "")
        case .invalidGuestCount:
            return NSLocalizedString("Максимальное количество гостей - \(Constants.maxGuestsCount). Минимальное - \(Constants.minGuestsCount)", comment: "")
        case .invalidPassword:
            return NSLocalizedString("Пароль должен быть больше 8 символов, на английском языке", comment: "")
        case .invalidAuthorization:
            return NSLocalizedString("Неверный логин или пароль", comment: "")
        case .invalidConfirmPassword:
            return NSLocalizedString("Пароли должны совпадать", comment: "")
        }
    }
}

enum TicketErrors: Error {
    case ticketAlreadySet, invalidEventId, invalidUserId, notEnoughSpace, ticketNotSet, userNoGoThrough
}

extension TicketErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ticketAlreadySet:
            return NSLocalizedString("Пользователь уже записан на это мероприятие", comment: "")
        case .invalidEventId:
            return NSLocalizedString("Неккоректное мероприятие", comment: "")
        case .invalidUserId:
            return NSLocalizedString("Неккоректный пользователь", comment: "")
        case .notEnoughSpace:
            return NSLocalizedString("Недостаточно мест", comment: "")
        case .ticketNotSet:
            return NSLocalizedString("Вы не записаны на данное мероприятие", comment: "")
        case .userNoGoThrough:
            return NSLocalizedString("Ошибка при пропуске. Повторите.", comment: "")
        }
    }
}

enum NetworkErrors: Error {
    case wrongBaseURL, dataError, serverError, wrongParameters, noInternet
}

extension NetworkErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongBaseURL:
            return NSLocalizedString("Некорректная подключение с серверу", comment: "")
        case .dataError:
            return NSLocalizedString("Некорректные данные", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .wrongParameters:
            return NSLocalizedString("Некорректные параметры при запросе", comment: "")
        case .noInternet:
            return NSLocalizedString("Отсутствует подключение к интернету", comment: "")
        }
    }
}

enum FireStorageErrors: Error {
    case wrongURL, imageError
}

extension FireStorageErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongURL:
            return NSLocalizedString("Некорректная ссылка на фото.", comment: "")
        case .imageError:
            return NSLocalizedString("Ошибка загрузки фото.", comment: "")
        }
    }
}
