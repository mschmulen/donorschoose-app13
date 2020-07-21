//
//  SchoolDetailView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct SchoolDetailView: View {
    
    @EnvironmentObject var appState: AppState
    
    @ObservedObject var store = DCSchoolStore(schoolID: "7746")
    
    @State var isFavorite: Bool = false
    @State var showActionSheet: Bool = false
    
    var schoolID: String
    var schoolName: String
    
    var header: some View {
        ZStack{
            Color(.blue)
                .edgesIgnoringSafeArea(.all)
                .frame(height:80)
            VStack() {
                HStack() {
                    Text(store.model?.name ?? "")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
    }

    var body: some View {
        VStack {
            header
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing:10) {
                    VStack(alignment: .leading) {
                        Text("City:")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        Text(store.model?.city ?? "")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }

                    VStack(alignment: .leading) {
                        Text("State:")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        Text(store.model?.state ?? "")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Poverty Level:")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        Text(store.model?.povertyLevel ?? "")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                }
                
                // School Proposals
                if store.model != nil {
                    if store.model!.proposals.count > 0 {
                        Text("School Proposals \(store.model!.proposals.count)")
                        .font(.system(size: 20, weight: .light, design: .rounded))
                    }
                    ForEach( store.model!.proposals) { proposal in
                        //NavigationLink(destination: TeacherDetailView(model:
                        VStack(alignment: .leading) {
                            Text(proposal.title)
                                .font(.system(size: 20, weight: .light, design: .rounded))
                            Text(proposal.shortDescription)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                        }
                        //}.buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        .onAppear {
            print("onAppear ")
            self.store.fetchSchool(schoolID: self.schoolID)
        }
    }
    
    private var trailingButton: some View {
        Group {
            if isFavorite {
                Button(action:onFavoriteTouch) { Image(systemName: "heart.circle.fill") }
            } else {
               Button(action:onFavoriteTouch) { Image(systemName: "heart") }
            }
        }
    }
    
    func onFavoriteTouch() {
        appState.addFavoriteSchool(id:schoolID, title:schoolName)
        isFavorite.toggle()
    }
    
    private var leadingButton: some View {
        HStack {
            Button(action:onMore) { Image(systemName: "plus") }
        }
    }
    
    func onMore() {
        showActionSheet.toggle()
    }
}

struct SchoolDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolDetailView(
            schoolID: "7746",
            schoolName:"schoolName"
        )
    }
}
