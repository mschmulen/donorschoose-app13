//
//  CoreDataStore.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

/// CoreDataStore Class
public final class CoreDataStore: ObservableObject {

    public let objectWillChange = ObservableObjectPublisher()
    
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

extension CoreDataStore {
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
}

extension CoreDataStore {
    
    public func addFavoriteProject( id: String, title:String, expirationDate:Date ) {
        let newModel = FavoriteProposal(context: context)
        newModel.title = title
        newModel.id = id
        newModel.dateFavorited = Date()
        newModel.expirationDate = expirationDate
        saveContext()
    }
    
    public func addFavoriteTeacher( id: String, title:String ) {
        let newModel = FavoriteTeacher(context: context)
        newModel.title = title
        newModel.id = id
        newModel.dateFavorited = Date()
        saveContext()
    }
    
    public func addFavoriteSchool( id: String, title:String ) {
        let newModel = FavoriteSchool(context: context)
        newModel.title = title
        newModel.id = id
        newModel.dateFavorited = Date()
        saveContext()
    }
    
    public func addFavoriteSearch( id: String ) {
        let newModel = FavoriteSearch(context: context)
        newModel.id = id
        newModel.dateFavorited = Date()
        saveContext()
    }
    
    public func addFavoriteSearch( id: String, title: String ) {
        let newModel = FavoriteSearch(context: context)
        newModel.id = id
        newModel.title = title
        newModel.dateFavorited = Date()
        saveContext()
    }
    
    
    
}
