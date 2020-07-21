//
//  ProposalRowView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ProposalRowView: View {
    
    var model: ProposalModel
    
    var imagePlaceHolder: some View {
        ZStack {
            Color(.blue).edgesIgnoringSafeArea(.all)
            Text("Loading")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.white)
        }
    }
    
    var body: some View {
        VStack {
            Text("\(model.title)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            HStack {
                AsyncSimpleImage(
                    imageURLString: model.thumbImageURL,
                    placeholder: imagePlaceHolder
                )
                    .frame(width: 100, height: 100)
                    .cornerRadius(5)
                Text(model.shortDescription)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
            }
            
            HStack {
                VStack {
                    Text("$ \(model.costToComplete)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text("Still Needed")
                    .font(.system(size: 13, weight: .light, design: .rounded))
                }.padding()
                
                Spacer()
                VStack {
                    Text("\(model.numDonors)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text("Donors")
                    .font(.system(size: 13, weight: .light, design: .rounded))
                }.padding()
            }
            Rectangle()
                .frame(height: 5)
            HStack {
                Text("22")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                Text("days left!")
                .font(.system(size: 18, weight: .medium, design: .rounded))
            }
        }
    }
}

struct ProposalRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalRowView(model: ProposalModel.mock)
    }
}
