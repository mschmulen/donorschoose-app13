//
//  InNeedView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct InNeedView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var appState: AppState
    
    var setTabIndexCallback: ((TopTabView.TabViewIndex) ->())?
    
    //@State private var models:[ProposalModel] = [ProposalModel]()
    
    @ObservedObject var store = DCProposalStore()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach( self.store.models) { model in
                        NavigationLink(destination: ProposalDetailView(model: model)) {
                            ProposalRowView(model: model)
                        }
                    }
                }
            }.onAppear {
                print("onAppear ")
                self.store.requestConfig = .sort(searchSortOption: SearchSortOption.urgency)
                //self.store.fetchCustom(requestConfig: .sort(searchSortOption: SearchSortOption.urgency))
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("In Need"), displayMode: .inline)
        }
    }
}
