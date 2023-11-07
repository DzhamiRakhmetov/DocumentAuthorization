//
//  LoginByDocumentViewModel.swift
//  DocumentAuthorization
//
//  Created by Dzhami on 02.11.2023.
//

import Foundation

final class LoginByDocumentViewModel {
    
    func authentificateUserBy(documentNumber: String, password: String) -> String {
        if let user = DocumentAuthorization.loginPassword.first(where: { $0.passportNumber == documentNumber }) {
            if user.password == password {
                return TextLabels.LoginByDocumentVC.autorizationSuccess
            } else {
                return TextLabels.LoginByDocumentVC.wrongPassword
            }
        } else {
            return TextLabels.LoginByDocumentVC.wrongEmail
        }
    }
}
