//
//  TeacherDetailView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct TeacherDetailView: View {
    
    @EnvironmentObject var appState: AppState
    
    @ObservedObject var store = DCTeacherStore(teacherID: "6495614")
    
    @State var isFavorite: Bool = false
    @State var showActionSheet: Bool = false
    
    var teacherID: String
    var teacherName: String
    
    var imagePlaceHolder: some View {
            ZStack {
                Color(.lightGray).edgesIgnoringSafeArea(.all)
                Text("")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        
    var header: some View {
            ZStack{
                Color(.blue)
                    //.edgesIgnoringSafeArea(.all)
                    .frame(height:80)
                VStack() {
                    HStack() {
                        Text(store.model?.name ?? "")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
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
                    //Text("schoolName: \(store.model?.schoolName ?? "~")")
                    if store.model?.schoolName != nil {
                        if store.model?.schoolID == nil {
                            VStack(alignment: .leading) {
                                Text("School:")
                                    .font(.system(size: 20, weight: .light, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(store.model!.schoolName!)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.padding()
                        } else {
                            NavigationLink(destination: SchoolDetailView(
                                schoolID: store.model!.schoolID!,
                                schoolName: store.model!.schoolName!
                            )){
                                Text(store.model!.schoolID!)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding()
                        }
                    }
                    
                    if store.model?.povertyLevel != nil {
                        VStack(alignment: .leading) {
                            Text(store.model!.povertyLevel!)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding()
                    }
                    
                    if store.model?.state != nil {
                        VStack(alignment: .leading) {
                            Text("State:")
                                .font(.system(size: 20, weight: .light, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(store.model!.state!)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        }.padding()
                    }
                    
                    //Text("schoolId: \(store.model?.schoolID ?? "~")")
                    // Text("city: \(store.model?.city ?? "~")")
                    // Text("zip: \(store.model?.zip ?? "~")")
                    
                }
                
                VStack(spacing:10) {
                    
                    if store.model?.totalFundedProposals != nil {
                        VStack(alignment: .leading) {
                            Text("Total Funded Proposals:")
                                .font(.system(size: 20, weight: .light, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(store.model!.totalFundedProposals!)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    if store.model?.totalProposals != nil {
                        VStack(alignment: .leading) {
                            Text("Total Proposals:")
                                .font(.system(size: 20, weight: .light, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text(store.model!.totalProposals!)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    if store.model?.totalSupporters != nil {
                        if !store.model!.totalSupporters!.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Total Supporters:")
                                    .font(.system(size: 20, weight: .light, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(store.model!.totalSupporters!)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    EmptyView()
                }.padding()
                
//                VStack(spacing:10) {
//
//                    VStack(alignment: .leading) {
//                        Text("Poverty Level:")
//                        .font(.system(size: 20, weight: .light, design: .rounded))
//
//                        Text("Nearly all-students from low-income households")
//                        .font(.system(size: 20, weight: .medium, design: .rounded))
//                    }
//
//                    VStack(alignment: .leading) {
//                        Text("Description:")
//                        .font(.system(size: 20, weight: .light, design: .rounded))
//                        Text("we need to insprie and spark creativity while learning")
//                        .font(.system(size: 20, weight: .medium, design: .rounded))
//                    }
//                }.padding()
                
//                Text("My Project:")
//                Text("\(model.name)")
//                    .padding()
//
//                Text(store.model.name)
            }
        }
        .onAppear {
            print("onAppear ")
            self.store.fetchTeacher(teacherID: self.teacherID)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Teacher"), displayMode: .inline)
        .navigationBarItems(leading: leadingButton, trailing: trailingButton)
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
        appState.addFavoriteTeacher(id:teacherID, title:teacherName)
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

struct TeacherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherDetailView(
            teacherID: "6495614",
            teacherName: "Some teacher name"
        )
    }
}
