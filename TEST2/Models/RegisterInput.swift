//
//  RegisterInput.swift
//  TEST2
//
//  Created by Ulan Nurmatov on 08.11.2021.
//

import Foundation

struct RegisterInput: Codable {
    
    let lastName: String
    let firstName: String
    let middleName: String
    let email: String
    let password: String
    let confirmPassword: String
}
