//
//  ProposalDetailView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ProposalDetailView: View {
    
    @EnvironmentObject var appState: AppState
    
    var model: ProposalModel
    
    @State var isFavorite: Bool = false
    @State var showActionSheet: Bool = false
    
    @State var percentCompleteProgressValue:Float = 0
    
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
            AsyncSimpleImage(
                imageURLString: model.imageURL,
                placeholder: imagePlaceHolder
            )
                .aspectRatio(contentMode: .fill)
                .frame(height:150)
                // .edgesIgnoringSafeArea(.all)
                .clipped()
            VStack {
                HStack {
                    NavigationLink(destination: TeacherDetailView(
                        store: DCTeacherStore(teacherID: model.teacherId)
                    )){
                        Text(model.teacherName)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                    }.buttonStyle(PlainButtonStyle())
                    Spacer()
                    Text( "\(model.city),\(model.state)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                }
                
                if model.extractedSchoolID == nil {
                    Text(model.schoolName)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                } else {
                    NavigationLink(destination: SchoolDetailView(
                        //store: DCSchoolStore(schoolID: model.extractedSchoolID!)
                    store: DCSchoolStore(schoolID: "44656")
                    )){
                        Text(model.schoolName)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // TODO: Extract this to a custom view
    var statusBar: some View {
        VStack {
            HStack(alignment: .center, spacing: 60) {
                VStack {
                    Text("$\(model.costToComplete)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text("Still Needed")
                        .font(.system(size: 13, weight: .light, design: .rounded))
                }
                
                VStack {
                    Text("\(model.percentFunded)%")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text("Funded")
                        .font(.system(size: 13, weight: .light, design: .rounded))
                }
                
                VStack {
                    Text("\(model.numDonors)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text("Donors")
                        .font(.system(size: 13, weight: .light, design: .rounded))
                }
            }
            // Text("\(model.percentFunded)")
            VStack(alignment: .leading) {
                ProgressBar(value: $percentCompleteProgressValue)
                    .frame(height: 10)
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
    }
    
    var body: some View {
        
        VStack {
            header
            statusBar
            ScrollView(.vertical, showsIndicators: false) {
                Text("\(model.title)")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                Text("\(model.fulfillmentTrailer)")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Text("My Students:")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Text("\(model.shortDescription)")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .padding()
                
                Text("My Project:")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Text("\(model.shortDescription)")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .padding()
                
                VStack {
                    Text("latitude \(model.totalPrice)")
                    Text("fundingStatus \(model.fundingStatus)")
                    Text("expirationDate \(model.expirationDate)")
                    Text("gradeLevel \(model.gradeLevel.name)")
                    Text("latitude \(model.latitude)")
                    Text("latitude \(model.povertyLevel)")
                }
            }
            
            Button(action: {
                if let fundURL = self.model.fundURL, let url = URL(string: fundURL) {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Give")
                    .foregroundColor(.white)
                    .padding(8)
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }
        }.onAppear(perform: {
            self.startProgressBar(percentFunded: self.model.percentFunded)
        })
        .navigationBarTitle(Text("Proposal"), displayMode: .inline)
        .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        .sheet(isPresented: $showActionSheet) {
            ProjectActionSheet(model: self.model)
                .environmentObject(self.appState)
        }
    }
    
    func startProgressBar(percentFunded: Int ) {
        self.percentCompleteProgressValue = 0.0
        for _ in 0...percentFunded {
            self.percentCompleteProgressValue += 0.01
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
        isFavorite.toggle()
        appState.addFavoriteProject(
            id:model.id,
            title:model.title,
            expirationDate: model.expirationDate
        )
    }
    
    private var leadingButton: some View {
        HStack {
            Button(action:onMore) { Image(systemName: "square.and.arrow.up") }
        }
    }
    
    func onMore() {
        showActionSheet.toggle()
    }
    
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalDetailView(model: ProposalModel.mock)
    }
}

// TODO: Clean up
// iOS 14
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-open-web-links-in-safari
// Link("Learn SwiftUI", destination: URL(string: "https://www.hackingwithswift.com/quick-start/swiftui")!)

struct ProjectActionSheet: View {
    
    @EnvironmentObject var appState: AppState
    
    var model: ProposalModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Button(action: {
                print( "TODO email")
            }) {
                Text("Email to a friend")
                    .foregroundColor(.red)
            }
            Button(action: {
                print( "TODO email")
            }) {
                Text("Open in Safari")
                    .foregroundColor(.red)
            }
            Button(action: {
                print( "TODO copy URL")
            }) {
                Text("Copy URL")
                    .foregroundColor(.red)
            }
            Button(action: {
                self.appState.addFavoriteProject(
                    id: self.model.id,
                    title: self.model.title,
                    expirationDate: self.model.expirationDate
                )
            }) {
                Text("Add to my favorites")
            }
        }
    }
}
