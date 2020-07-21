//
//  ProposalModel.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

public struct ProposalModel: Codable, Identifiable {
    
    public let id: String
    public let title: String
    public let teacherId: String
    public let teacherName: String
    public let schoolName: String
    public let state: String
    public let city: String
    public let costToComplete: String
    public let numDonors: Int
    public let percentFunded: Int
    public let proposalURL: String
    public let fulfillmentTrailer: String
    public let fundingStatus: String
    public let gradeLevel: GradeLevelModel
    public let imageURL: String?
    public let latitude: String
    public let longitude: String
    public let thumbImageURL: String?
    public let povertyLevel: String
    public let schoolUrl: String
    public let extractedSchoolID: String?
    public let totalPrice: String
    public let zip: String
    public let expirationDate: Date
    // public let freeShipping: Bool
    public let fundURL: String?
    public let shortDescription: String
    
    public let synopsis: String?
    
    // codable
    enum CodingError: Error {
        case decoding(String)
    }
    
    public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        
        title = try values.decode(String.self, forKey: .title)
        teacherId = try values.decode(String.self, forKey: .teacherId)
        teacherName = try values.decode(String.self, forKey: .teacherName)
        schoolName = try values.decode(String.self, forKey: .schoolName)
        state = try values.decode(String.self, forKey: .state)
        city = try values.decode(String.self, forKey: .city)
        costToComplete = try values.decode(String.self, forKey: .costToComplete)
        
        numDonors = Int( try values.decode(String.self, forKey: .numDonors) ) ?? 0
        percentFunded = Int( try values.decode(String.self, forKey: .percentFunded) )!
        proposalURL = try values.decode(String.self, forKey: .proposalURL)
        fulfillmentTrailer = try values.decode(String.self, forKey: .fulfillmentTrailer)
        fundingStatus = try values.decode(String.self, forKey: .fundingStatus)
        gradeLevel = try values.decode(GradeLevelModel.self, forKey: .gradeLevel)
        imageURL = try? values.decode(String.self, forKey: .imageURL)
        latitude = try values.decode(String.self, forKey: .latitude)
        longitude = try values.decode(String.self, forKey: .longitude)
        thumbImageURL = try? values.decode(String.self, forKey: .thumbImageURL)
        povertyLevel = try values.decode(String.self, forKey: .povertyLevel)
        schoolUrl = try values.decode(String.self, forKey: .schoolUrl)
        
        totalPrice = try values.decode(String.self, forKey: .totalPrice)
        zip = try values.decode(String.self, forKey: .zip)
        
        fundURL = try? values.decode(String.self, forKey: .fundURL)
        shortDescription = try values.decode(String.self, forKey: .shortDescription)
                
        if let synopsisString = ((try? values.decode(String?.self, forKey: .synopsis)) as String??) {
            synopsis = synopsisString
        } else {
            synopsis = shortDescription
        }
        
        let expirationDateString = try values.decode(String.self, forKey: .expirationDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: expirationDateString ) {
            expirationDate = date
        } else {
            throw CodingError.decoding("Decoding Error: \(dump(values))")
        }
        
        if let _ = URL(string: schoolUrl) {
            let schoolURLpaths = schoolUrl.components(separatedBy: "/")
            // MAS TODO , Fix This
            let secondLastPath = schoolURLpaths[schoolURLpaths.count - 2]
            let schoolID = secondLastPath
            extractedSchoolID = schoolID
        } else {
            throw CodingError.decoding("Decoding Error: \(dump(values))")
        }
    }
}

extension ProposalModel {
    
    static var mock:ProposalModel {
        
        let str = """
{
"id": "5005477",
"proposalURL": "https://www.donorschoose.org/project/tablets-for-our-title-i-math-and-science/5005477/?challengeid=20785042&offpage=true&utm_source=api&utm_medium=feed&utm_content=bodylink&utm_campaign=DONORSCHOOSE",
  "fundURL": "https://secure.donorschoose.org/donors/givingCart.html?proposalid=5005477&donationAmount=45&challengeid=20785042&offpage=true&utm_source=api&utm_medium=feed&utm_content=fundlink&utm_campaign=DONORSCHOOSE",
  "imageURL": "https://www.donorschoose.org/teacher/photo/u6495614?size=sm&t=1594310205112",
  "retinaImageURL": "https://www.donorschoose.org/teacher/photo/u6495614?size=retina&t=1594310205112",
  "thumbImageURL": "https://www.donorschoose.org/teacher/photo/u6495614?size=thmb&t=1594310205112",
  "title": "Tablets for Our Title I Math and Science Classroom",
  "shortDescription": "I teach in a public 4th-grade classroom at a Title I school. I have 40 new scholars walking through my door in a few short weeks. These students have been learning from home since March but many...",
  "fulfillmentTrailer": "Help me give my students tablets to enhance their learning experience in our classroom.",
  "snippets": [],
  "percentFunded": "91",
  "numDonors": "15",
  "costToComplete": "59.39",
  "studentLed": false,
  "numStudents": "40",
  "professionalDevelopment": false,
  "distanceLearningProject": false,
  "matchingFund": {
    "matchingKey": "",
    "ownerRegion": "",
    "name": "",
    "donorSalutation": "",
    "type": "",
    "matchImpactMultiple": "",
    "multipleForDisplay": "",
    "logoURL": "",
    "amount": "0.00",
    "description": ""
  },
  "teacherFFPromoCodeFund": {
    "eligible": "true",
    "deadline": "July 18",
    "code": "LIFTOFF",
    "matchingKey": "LIFTOFF20",
    "ownerRegion": "",
    "name": "The DonorsChoose.org New Teacher Fund",
    "donorSalutation": "The DonorsChoose New Teacher Fund",
    "type": "PROMO",
    "logoURL": "liftoff.gif",
    "description": ""
  },
  "totalPrice": "679.98",
  "freeShipping": "true",
  "teacherId": "6495614",
  "teacherName": "Mrs. Moore",
  "gradeLevel": {
    "id": "2",
    "name": "Grades 3-5"
  },
  "povertyLevel": "More than half of students from low‑income households",
  "povertyType": {
    "label": "MODERATEHIGH",
    "name": "More than half of students from low‑income households",
    "range": "51-75%",
    "showPovertyLevel": "true"
  },
  "teacherTypes": [],
  "schoolTypes": [
    {
      "id": 3,
      "name": "Special Education"
    },
    {
      "id": 14,
      "name": "Kia (partner)"
    },
    {
      "id": 12,
      "name": "Horace Mann (partner)"
    }
  ],
  "schoolName": "Colson Elementary School",
  "schoolUrl": "https://www.donorschoose.org/school/colson-elementary-school/59270/",
  "city": "Seffner",
  "zip": "33584-5459",
  "state": "FL",
  "stateFullName": "Florida",
  "latitude": "27.982496000000000",
  "longitude": "-82.274016000000000",
  "zone": {
    "id": "312",
    "name": "Florida"
  },
  "subject": {
    "id": "6",
    "name": "Applied Sciences",
    "groupId": "4"
  },
  "additionalSubjects": [{
    "id": "8",
    "name": "Mathematics",
    "groupId": "4"
  }],
  "resource": {
    "id": "7",
    "name": "Computers &amp; Tablets"
  },
  "expirationDate": "2020-11-09",
  "expirationTime": 1604898000000,
  "fundingStatus": "needs funding"
}
"""
        let data = Data(str.utf8)
        
        do {
            //let json = try JSONSerialization.jsonObject(with: data, options: [])
            let model = try JSONDecoder().decode(ProposalModel.self, from: data)
            return model
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            fatalError()
        }
    }
}
