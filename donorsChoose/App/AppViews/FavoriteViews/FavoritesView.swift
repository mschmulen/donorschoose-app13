//
//  FavoritesView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct FavoritesView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var appState: AppState
    
    @FetchRequest(
        entity: FavoriteProposal.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FavoriteProposal.title, ascending: true)
        ]
    )
    var proposals: FetchedResults<FavoriteProposal>
    
    @FetchRequest(
        entity: FavoriteSchool.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FavoriteSchool.title, ascending: true)
        ]
    )
    var schools: FetchedResults<FavoriteSchool>
    
    @FetchRequest(
        entity: FavoriteTeacher.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FavoriteTeacher.title, ascending: true)
        ]
    )
    var teachers: FetchedResults<FavoriteTeacher>
    
    @FetchRequest(
        entity: FavoriteSearch.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FavoriteSearch.title, ascending: true)
        ]
    )
    var searches: FetchedResults<FavoriteSearch>
    
    var setTabIndexCallback: ((TopTabView.TabViewIndex) ->())?
    
    var body: some View {
        NavigationView {
            List {
                
                if proposals.count != 0 {
                    Section(header:Text("Proposals")) {
                        ForEach(proposals, id: \.title) {
                            FavoriteProposalRow(
                                model: $0
                            )
                        }
                        .onDelete(perform: deleteProposalModel)
                    }
                }
                
                if teachers.count != 0 {
                    Section(header:Text("Teachers")) {
                        ForEach(teachers, id: \.title) {
                            FavoriteTeacherRow(
                                model: $0
                            )
                            
//                            NavigationLink(destination: TeacherDetailView(
//                                teacherID: $0.id,
//                                teacherName: $0.title
//                            )){
//                                FavoriteTeacherRow(
//                                    model: $0
//                                )
//                            }.buttonStyle(PlainButtonStyle())
                            
                            
                        }
                        .onDelete(perform: deleteTeacherModel)
                    }
                }
                
                if schools.count != 0 {
                    Section(header:Text("Schools")) {
                        ForEach(schools, id: \.title) {
                            FavoriteSchoolRow(
                                model: $0
                            )
                        }
                        .onDelete(perform: deleteSchoolModel)
                    }
                }
                
                if searches.count != 0 {
                    Section(header:Text("Searches")) {
                        ForEach(searches, id: \.id) {
                            FavoriteSearchRow(
                                model: $0
                            )
                        }
                        .onDelete(perform: deleteSearchModel)
                    }
                }
            }
            .navigationBarTitle(Text("Favorites"))
            .navigationBarItems(trailing:
                NavigationLink(destination:CustomSearchView(onComplete: nil)) {
                    Image(systemName: "plus")
                }
            )
        }
    }
    
    func deleteProposalModel(at offsets: IndexSet) {
        offsets.forEach { index in
            let model = self.proposals[index]
            self.managedObjectContext.delete(model)
        }
        saveContext()
    }
    
    func deleteTeacherModel(at offsets: IndexSet) {
        offsets.forEach { index in
            let model = self.teachers[index]
            self.managedObjectContext.delete(model)
        }
        saveContext()
    }
    
    func deleteSchoolModel(at offsets: IndexSet) {
        offsets.forEach { index in
            let model = self.schools[index]
            self.managedObjectContext.delete(model)
        }
        saveContext()
    }
    
    func deleteSearchModel(at offsets: IndexSet) {
        offsets.forEach { index in
            let model = self.searches[index]
            self.managedObjectContext.delete(model)
        }
        saveContext()
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
}

