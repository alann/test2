//
//  ProfileInput.swift
//  TEST2
//
//  Created by Ulan Nurmatov on 08.11.2021.
//

import Foundation

struct ProfileInput: Codable {
    
    let lastName: String
    let firstName: String
    let middleName: String?
    let birthplace: String
    let dateOfBirth: String?
    let organization: String?
    let position: String?
    let topics: [InterestTopic]
}

struct InterestTopic: Codable, Equatable {
    
    let name: String
}
