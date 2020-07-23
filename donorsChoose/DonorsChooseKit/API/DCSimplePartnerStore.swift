//
//  DCPartnerStore.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

public final class DCPartnerStore: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    private var url:URL {
        URL(string: "http://api.donorschoose.org/common/json-teacher.html?teacher=\(teacherID)&APIKey=\(DCAPIKey)")!
    }
    
    var teacherID: String
    
    @Published public var model: TeacherModel? = TeacherModel.mock {
        willSet {
            updateChanges()
        }
    }
    
    public init(teacherID:String) {
        self.teacherID = teacherID
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

extension DCPartnerStore {
    
    public func fetchLegacy(teacherID: String) {
        self.teacherID = teacherID
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                //fatalError("Error: \(error.localizedDescription)")
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                //fatalError("Error: invalid HTTP response code")
                print("Error: invalid HTTP response code")
                return
            }
            guard let data = data else {
                //fatalError("Error: missing response data")
                print("Error: missing response data")
                return
            }
            
            do {
                //print( "Request info: \(String(data:data, encoding: .utf8))")
                //if let debugString =
                
                let teacher = try JSONDecoder().decode(TeacherModel.self, from: data)
                //let projectModel = try JSONDecoder().decode(ProjectNetworkModel.self, from: data)
                //print( "projectModel \(projectModel)")
                //print( "\(projectModel.proposals.count)")
                DispatchQueue.main.async {
                    self.model = teacher
                }
            }
            catch {
                print("Error: \(error.localizedDescription)")
                //                    print("error in JSONSerialization \(error)")
                //                    //scallback([ProposalModel](), APIError.networkSerialize)
            }
        }
        task.resume()
    }
}

