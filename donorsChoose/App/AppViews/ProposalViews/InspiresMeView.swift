//
//  InspiresMeView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

struct InspiresMeView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var appState: AppState
    
    var setTabIndexCallback: ((TopTabView.TabViewIndex) ->())?
    
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
    
    @ObservedObject var store = DCProposalStore()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    
                    if searches.count != 0 {
                        Section(header:Text("Searches")) {
                            ForEach(searches, id: \.id) {
                                FavoriteSearchRow(
                                    model: $0
                                )
                            }
                        }
                    }
                    
//                    if teachers.count != 0 {
//                        Section(header:Text("Teachers")) {
//                            ForEach(teachers, id: \.title) {
//                                FavoriteTeacherRow(
//                                    model: $0
//                                )
//                            }
//                        }
//                    }
//
//                    if schools.count != 0 {
//                        Section(header:Text("Schools")) {
//                            ForEach(schools, id: \.title) {
//                                FavoriteSchoolRow(
//                                    model: $0
//                                )
//                            }
//                        }
//                    }
                    
                    Section(header: Text("Search")) {
                        ForEach( self.store.models) { model in
                            NavigationLink(destination: ProposalDetailView(model: model)) {
                                ProposalRowView(model: model)
                            }
                        }
                    }
                }
            }.onAppear {
                self.store.requestConfig = .keyword(keyword: "Science")
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Inspires Me")
        }
    }
}
