//
//  TopTabView.swift
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct TopTabView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var appState: AppState
    
    @State private var selectedTab = TabViewIndex.inNeed.rawValue
    
    public enum TabViewIndex: Int {
        case inNeed = 0
        case nearMe = 1
        case inspiresMe = 2
        case favorites = 3
        case more = 4
    }
    
    private var tabs: [TabViewIndex] = [.inNeed, .nearMe, .inspiresMe, .favorites, .more]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            if tabs.contains(.inNeed) {
                InNeedView(setTabIndexCallback: setActiveTabView)
                    .environmentObject(appState)
                    .tabItem {
                        Image(systemName:"hourglass")
                        // .font(.system(size: 28, weight: .light))
                        Text("In Need")
                }.tag(TabViewIndex.inNeed.rawValue)
            }
            
            if tabs.contains(.nearMe) {
                NearMeView(setTabIndexCallback: setActiveTabView)
                    .environmentObject(appState)
                    .tabItem {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Near Me")
                }.tag(TabViewIndex.nearMe.rawValue)
            }
            
            if tabs.contains(.inspiresMe) {
                InspiresMeView(
                    setTabIndexCallback: setActiveTabView
                )
                    .environmentObject(appState)
                    .tabItem {
                        Image(systemName:"lightbulb")
                        Text("Inspires Me")
                }.tag(TabViewIndex.inspiresMe.rawValue)
            }
            
            if tabs.contains(.favorites) {
                FavoritesView(
                    setTabIndexCallback: setActiveTabView
                )
                    .environmentObject(appState)
                    .tabItem {
                        Image(systemName: "heart.circle")
                        Text("Favorites")
                }.tag(TabViewIndex.favorites.rawValue)
            }
            
            if tabs.contains(.more) {
                MoreView(
                    setTabIndexCallback: setActiveTabView
                )
                    .environmentObject(appState)
                    .tabItem {
                        Image(systemName: "house")
                        Text("More")
                }.tag(TabViewIndex.more.rawValue)
            }
            
        }
        .onAppear {
           
        }
//        .sheet(isPresented: $showSignIn) {
//            YackView(enableCancelButton: true)
//                .environmentObject(self.appState)
//            // .environment(\.window, self.window)
//        }
    }//end body
    
    func setActiveTabView(_ tabIndex: TabViewIndex) {
        self.selectedTab = tabIndex.rawValue
    }
    
}

#if DEBUG
@available(iOS 13.0, *)
struct TopTabView_Previews: PreviewProvider {
    static var previews: some View {
        TopTabView()
    }
}
#endif
