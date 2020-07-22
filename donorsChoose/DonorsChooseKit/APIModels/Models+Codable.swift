//
//  Models+Codable.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

public typealias Identifier = String

public struct GradeLevelModel : Codable {
    let id: String
    let name: String
    
//    private enum CodingKeys: String, CodingKey {
//        case name
//        case id
//    }
    
}

public struct MatchingFundModel : Codable {
    
    let amount: String
    let description: String
    let donorSalutation: String
    let faqURL: String
    let logoURL: String
    let matchingKey: String
    let name: String
    let ownerRegion: String
    let type: String
    
//    private enum CodingKeys: String, CodingKey {
//        case amount
//        case description
//    }

}

public struct ResourceModel : Codable {
    let id: String
    let name: String
}

public struct SchoolTypeModel : Codable {
    let id: String
    let name: String
}

public struct SubjectModel : Codable {
    let subject: String
    let groupId: String
    let id: String
    let name: String
}

public struct ZoneModel : Codable {
    let id: String
    let name: String
}

