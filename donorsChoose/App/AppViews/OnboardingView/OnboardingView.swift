//
//  OnboardingView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct OnBoardingView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var appState: AppState
    
    @State var locationViewModel: LocationViewModel?
    
    var body: some View {
        VStack {
            Text("OnBoardingView")
                .padding()
            Text("Welcome !")
                .padding()
            
            VStack {
                
                Text("Enable Locaiton Services so we can find exciting projects near you !")
                    .padding()
                Button(action: {
                    self.locationViewModel = LocationViewModel()
                    let location = self.locationViewModel?.location
                    print( "location")
                }) {
                    Text("Enable Location Services")
                }.padding()
                
            }.padding()
            
            Spacer()
            VStack {
                Button(action: {
                    self.appState.changeTopView(topView: .tabView)
                }) {
                    Text("Exit")
                }
            }.padding()
        }
    }
}
