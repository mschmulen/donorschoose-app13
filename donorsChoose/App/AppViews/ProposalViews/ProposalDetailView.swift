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
                imageURLString: model.thumbImageURL,
                //imageURLString: model.imageURL,
                placeholder: imagePlaceHolder
            )
                .aspectRatio(contentMode: .fill)
//                .aspectRatio(contentMode: .fit)
//                .aspectRatio(contentMode: .fill)
                //.frame(width:geo.size.width)//, height:200)
                .frame(height:150)//, height:200)
                .clipped()
                //.scaleEffect(self.scale)
            VStack {
                HStack {
                    NavigationLink(destination: TeacherDetailView(
                        teacherID: model.teacherId,
                        teacherName: model.teacherName
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
                        schoolID: model.extractedSchoolID!,
                        schoolName: model.schoolName
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
    
    var statusBar: some View {
        VStack {
            HStack {
                VStack {
                    Text("Still Needed")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text("\(model.costToComplete)")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                }.padding()
                Spacer()
                VStack {
                    Text("Donors")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text("\(model.numDonors)")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                }.padding()
            }
            // Text("\(model.percentFunded)")
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
        }
        .navigationBarItems(leading: leadingButton, trailing: trailingButton)
        .sheet(isPresented: $showActionSheet) {
            ProjectActionSheet()
                .environmentObject(self.appState)
            // .environment(\.window, self.window)
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
    
    var body: some View {
        VStack {
            Text("yack")
            Text("yack")
            Text("yack")
        }
    }
}
