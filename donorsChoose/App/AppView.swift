//
//  AppView.swift
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
struct AppView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            
            if appState.topView == .none {
                Text( "none")
            }
            
            if appState.topView == .tabView {
                TopTabView()
                    .environmentObject(appState)
            }
            
            if appState.topView == .onboardingView {
                OnBoardingView()
                    .environmentObject(appState)
            }
            
            EmptyView()
        }.onAppear {
            print( "AppView.onAppear")
        }
    }//end body
    
}

#if DEBUG
@available(iOS 13.0, *)
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
#endif
