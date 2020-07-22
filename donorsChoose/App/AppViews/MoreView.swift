//
//  MoreView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct MoreView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var appState: AppState
    
    @ObservedObject var store = DCProposalStore()
    
    var setTabIndexCallback: ((TopTabView.TabViewIndex) ->())?
    
    var body: some View {
        NavigationView {
            List  {
                Section(header:Text("ABOUT")) {
                    Text("Donors Choose Project Finder \(appState.currentAppInfo.appShortVersion)")
                    
                    NavigationLink(
                        destination: Text("TODO")
                    ){
                        Text("About This App")
                    }
                    
                    NavigationLink(
                        destination: Text("TODO")
                    ){
                        Text("Search Tools")
                    }
                }
                
                Section(header:Text("STATS ABOUT THIS APP")) {
                    Text("Amount Donated: XXX")
                    Text("Students Impacted: XXX")
                    Text("Teachers Supported: XXX")
                    Text("Schools Reached: XXX")
                    
                    NavigationLink(
                        destination: Text("TODO")
                    ){
                        Text("More Stats about this app")
                    }
                }
                
                Section(header:Text("DEV")) {
                    Button(action: {
                        self.appState.topView = .onboardingView
                    }) {
                        Text("Show onboarding")
                    }
                }
            }
            .navigationBarTitle(Text("More"), displayMode: .inline)
        }
    }
}
