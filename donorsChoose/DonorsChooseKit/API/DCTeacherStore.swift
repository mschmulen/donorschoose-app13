//
//  DCTeacherStore.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

public final class DCTeacherStore: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    @Published public var teacherID: String = "" {
        willSet {
            updateChanges()
        }
        didSet {
            fetch()
        }
    }
    
    private var url:URL {
        URL(string: "http://api.donorschoose.org/common/json-teacher.html?teacher=\(teacherID)&APIKey=\(DCAPIKey)")!
    }
    
    @Published public var model: TeacherModel? {
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

extension DCTeacherStore {
    
    public func fetch() {
        
        if teacherID.isEmpty {
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
                //print( "Request info: \(String(data:data, encoding: .utf8))")
                
                let teacher = try JSONDecoder().decode(TeacherModel.self, from: data)
                self.model = teacher
                self.updateChanges()
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
