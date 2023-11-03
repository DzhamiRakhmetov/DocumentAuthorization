//
//  User.swift
//  DocumentAuthorization
//
//  Created by Dzhami on 02.11.2023.
//

import Foundation

struct DocumentAuthorization {
    let passportNumber: String
    let password: String
}

extension DocumentAuthorization {
    static var loginPassword = [DocumentAuthorization(passportNumber: "501033444", password: "Hello12345")]
}
