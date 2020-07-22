//
//  NearMeView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct NearMeView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var appState: AppState
    
    var setTabIndexCallback: ((TopTabView.TabViewIndex) ->())?
    
    @ObservedObject var store = DCProposalStore()
    
    var locationViewModel: LocationViewModel = LocationViewModel()
    
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
                if let _ = self.locationViewModel.location {
                    self.store.requestConfig = .nearestGeo(
                        latitude: self.locationViewModel.userLatitude,
                        longitude: self.locationViewModel.userLongitude
                    )
                } else {
                    self.store.requestConfig = .sort(searchSortOption: SearchSortOption.urgency)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Near Me"), displayMode: .inline)
        }
    }
}
