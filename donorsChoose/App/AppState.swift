//
//  AppState.swift
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class AppState: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    enum TopView: CaseIterable {
        case tabView
        case onboardingView
        case none
    }
    
    // nav stuff
    @Published var topView: TopView = .tabView {
        willSet {
            update()
        }
    }
    
    let coreDataStore:CoreDataStore
    let currentDeviceInfo: DeviceModel = DeviceModel()
    let currentAppInfo: AppModel = AppModel()
    let showOnboarding: Bool = false
    
    init(
        context: NSManagedObjectContext
    ) {
        self.coreDataStore = CoreDataStore(context: context)
    }
    
    private func update() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
}

// MARK: - Favorit stuff
extension AppState {
    
    public func addFavoriteProject( id: String, title:String, expirationDate:Date ) {
        coreDataStore.addFavoriteProject(id:id, title:title, expirationDate:expirationDate)
    }
    
    public func addFavoriteTeacher( id: String, title:String ) {
        coreDataStore.addFavoriteTeacher(id:id, title:title)
    }
    
    public func addFavoriteSchool( id: String, title:String ) {
        coreDataStore.addFavoriteSchool(id:id, title:title)
    }
    
    public func addFavoriteSearch( id: String, keyword: String ) {
        coreDataStore.addFavoriteSearch(
            id: id,
            title: keyword
        )
    }
    
}

// MARK: - User stuff
extension AppState  {
    
    public func changeTopView( topView: TopView ) {
        self.topView = topView
        update()
    }
    
}
// MARK: - User stuff
extension AppState  {
    
    public enum AppStateError: Error {
        case unknown
    }
    
    public func onStartup() {
    }//end onStartup
}
 
