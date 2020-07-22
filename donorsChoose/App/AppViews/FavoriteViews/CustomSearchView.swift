//
//  CustomSearchView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct CustomSearchView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var appState: AppState
    
    static let DefaultModelTitle = "An untitled search"
    
    @ObservedObject var store = DCProposalStore()
    
    @State var keyword = ""
    @State var id = UUID().uuidString
    @State var dateFavorited = Date()
    let onComplete: ((String, String, Date) -> Void)?
    
    var body: some View {
        NavigationView {
            Form {
                
                SearchView(requestConfig: $store.requestConfig)
                Section(header: Text("Results:")) {
                    List {
                        ForEach( self.store.models) { model in
                            NavigationLink(destination: ProposalDetailView(model: model)) {
                                ProposalRowView(model: model)
                            }
                        }
                    }
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                    switch self.store.requestConfig {
                    case .keyword(let keyword):
                        self.appState.addFavoriteSearch(
                            id: UUID().uuidString,
                            keyword: keyword
                        )
                        self.presentationMode.wrappedValue.dismiss()
                    default:
                        break
                    }
                }) {
                    Text("SAVE")
                }
            )
            //.navigationBarTitle(Text("Add Model"), displayMode: .inline)
            .onAppear(perform: {
                print( "on Appear")
                self.store.refresh()
            })
                
        }
    }
    
}

struct SearchView: View {
    
    @Binding var requestConfig:ProjectSearchDataModel
    
    @State var searchKeyword: String = "Math"
    
    var body: some View {
        VStack {
            Text("search")
            TextField("Search", text: $searchKeyword)
            Button(action: {
                self.requestConfig = ProjectSearchDataModel.keyword(keyword: self.searchKeyword)
            }) {
                Text("Update")
            }
        }.onAppear {
            self.requestConfig = ProjectSearchDataModel.keyword(keyword: self.searchKeyword)
        }
    }
}

