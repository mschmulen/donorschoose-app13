//
//  SchoolModel.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

public struct SchoolModel : Codable, Identifiable {
    public let id: String
    public let name: String
    public let schoolURL: String
    public let povertyLevel: String
    public let city: String
    public let zip: String
    public let state: String
    public let totalProposals: String
    public let proposals: Array<ProposalModel>
}

extension SchoolModel {
    
    static var mock:SchoolModel {
        let str = """
{
"id": "5005477",
"name": "some school name",
"schoolURL": "https://www.donorschoose.org/school/colson-elementary-school/59270/",
"povertyLevel": "some povertyLevel info",
"city": "Austin",
"zip": "76021",
"state": "TX",
"totalProposals":"2",
"proposals": []
}
"""
        let data = Data(str.utf8)
        do {
            let model = try JSONDecoder().decode(SchoolModel.self, from: data)
            return model
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            fatalError()
        }
    }
}
