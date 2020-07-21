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
                Text("userLatitude: \(locationViewModel.userLatitude)")
                Text("userLongitude: \(locationViewModel.userLongitude)")
                List {
                    ForEach( self.store.models) { model in
                        NavigationLink(destination: ProposalDetailView(model: model)) {
                            ProposalRowView(model: model)
                        }
                    }
                }
            }.onAppear {
                print("onAppear ")
                if let location = self.locationViewModel.location {
                    print( "location found \(location.coordinate)")
                    
                    self.store.requestConfig = .nearestGeo(
                        latitude: self.locationViewModel.userLatitude,
                        longitude: self.locationViewModel.userLongitude
                    )
                    
//                    self.store.fetchCustom(
//                        requestConfig: .nearestGeo(
//                            latitude: self.locationViewModel.userLatitude,
//                            longitude: self.locationViewModel.userLongitude
//                        )
//                    )
                }
                
                self.store.requestConfig = .sort(searchSortOption: SearchSortOption.urgency)
                
                //self.store.fetchCustom(requestConfig: .sort(searchSortOption: SearchSortOption.urgency))
                
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Near Me")
        }
    }
}
