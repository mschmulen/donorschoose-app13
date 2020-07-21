//
//  TeacherModel.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

public struct TeacherZone : Codable {
    let id: String?// = 402;
    let name: String? // = "California (North)";
}

public struct TeacherGradeLevel : Codable {
    let id: String?// = 10;
    let name: String? // = 10
}

public struct TeacherPovertyType : Codable {
    let label: String // = MODERATEHIGH;
    let name: String // = "More than half of students from low\U2011income households";
    let range: String // = "51-75%";
//        showPovertyLevel = true;
}

public struct TeacherModel : Codable, Identifiable {
    
    let description: String

    public let id: String
    let joinedOn:String
    // latitude = "";
    // longitude = "";
    let name: String
    let photoURL: String
    let teacherChallengeId:String
    let profileURL: String
    
    let donationsTotalCount: String?
    let povertyLevel: String?
    let schoolID: String?
    let schoolName: String?
    let state: String?
    let city: String?
    let zip: String?
    let totalProposals: String?
    
    let totalFundedProposals: String?
    let totalSupporters: String?
    
    let zone: TeacherZone?
    let gradeLevel: TeacherGradeLevel?
    let povertyType: TeacherPovertyType?
    
    let heavyLoadDonationHistoryMessage: String?
    
//    proposalMessages =     (
//    );
//    proposals =     (
//    );
//    supporters =     (
//    );
}

extension TeacherModel {
    static var mock:TeacherModel {
            let str = """
{
"id": "6495614",
"description": "These 12 Amazon Fire tablets will allow my students to be introduced to different online resources and engage in fun learning games that support the content being taught. Our school is a Title I school and we do not have access to any laptops or tablets like other schools in our community. Due to COVID-19, students will not be able to share books or other resources that cannot easily be sanitized so I believe these tablets will play a major roll in student engagement and achievement this school year. There are two desktop computers that my students can share but have to social distance, we will not be able to use them in group settings like we typically would. Giving these students the ability to still use technology and connect with each other virtually for project based learning, assessments, and differentiation will be the key to keeping the students healthy, safe, and engaged. Because most of my students come from low socioeconomic backgrounds, this might be the only technology they access this year. This project will guarantee that these scholars have the tools they need to assist in their success. These scholars greatly appreciate you giving them the ability to engage in online learning like the other schools in the surrounding community!",
"joinedOn": "2019-06-15 09:14:04.608",
"name": "Mrs. Moore",
"photoURL": "https://storage.donorschoose.net//teacher/photo/u6495614?size=sm&t=1594310205112",
"teacherChallengeId": "21404347",
"profileURL": "https://www.donorschoose.org/classroom/6495614",
"schoolId": "59270",
"schoolName": "Colson Elementary School",
"city": "Seffner",
"zip": "33584-5459",
"state": "FL",
"latitude": "27.982496000000000",
"longitude": "-82.274016000000000",
"totalProposals": "1",
"totalFundedProposals": "1",
"proposals": [],
"proposalMessages": [],
"totalSupporters": "",
"supporters": [],
"donationsTotalCount": "",
"donations": [],
"gradeLevel": {
  "id": "null",
  "name": ""
},
"povertyLevel": "More than half of students from low‑income households",
"povertyType": {
  "label": "MODERATEHIGH",
  "name": "More than half of students from low‑income households",
  "range": "51-75%",
  "showPovertyLevel": "true"
},
"zone": {
  "id": "312",
  "name": "Florida"
}
}
"""
            let data = Data(str.utf8)
            do {
                let model = try JSONDecoder().decode(TeacherModel.self, from: data)
                return model
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                fatalError()
            }
        }
    
    
}



//    static var mock:TeacherModel {
//        let str = """
//{
//"description": "mock description...",
//"id": "5005477",
//"joinedOn":"2020-11-09",
//"name": "mock Teacher Name",
//"photoURL": "https://www.donorschoose.org/teacher/photo/u6495614?size=sm&t=1594310205112",
//"teacherChallengeId":"String",
//"profileURL": "https://www.donorschoose.org/school/colson-elementary-school/59270/"
//}
//"""
//        let data = Data(str.utf8)
//        do {
//            let model = try JSONDecoder().decode(TeacherModel.self, from: data)
//            return model
//        } catch let error as NSError {
//            print("Failed to load: \(error.localizedDescription)")
//            fatalError()
//        }
//    }
