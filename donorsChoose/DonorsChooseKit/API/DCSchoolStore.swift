//
//  DCSchoolStore.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

public final class DCSchoolStore: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    private var url:URL {
        URL(string: "http://api.donorschoose.org/common/json-school.html?school=\(schoolID)&APIKey=\(DCAPIKey)")!
    }
    
    @Published public var schoolID: String = "" {
        willSet {
            updateChanges()
        }
        didSet {
            fetch()
        }
    }
    
    @Published public var model: SchoolModel? {
        willSet {
            updateChanges()
        }
    }
    
    public init(schoolID: String) {
        self.schoolID = schoolID
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

extension DCSchoolStore {
    
    public func fetch() {
        
        if schoolID.isEmpty {
            return
        }
        
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
                
                print( "School Request info: \(String(data:data, encoding: .utf8))")
                
                let school = try JSONDecoder().decode(SchoolModel.self, from: data)
                //let projectModel = try JSONDecoder().decode(ProjectNetworkModel.self, from: data)
                //print( "projectModel \(projectModel)")
                //print( "\(projectModel.proposals.count)")
                DispatchQueue.main.async {
                    self.model = school
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
