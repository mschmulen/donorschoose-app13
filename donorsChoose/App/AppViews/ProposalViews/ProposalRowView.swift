//
//  ProposalRowView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ProposalRowView: View {
    
    var model: ProposalModel
    
    @State var percentComplete:CGFloat = 0
    
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
            VStack(alignment: .leading) {
                GeometryReader { geometry in
                    ZStack {
                        Rectangle()
                            .frame(width: geometry.size.width * 0.5, height: 5)
                            .foregroundColor(.gray)
//                            .alignmentGuide(.leading) { (dim) -> CGFloat in
//                                0
//                        }
                        Rectangle()
                            .frame(width: geometry.size.width * self.percentComplete, height: 3, alignment: .leading)
                            .foregroundColor(.green)
                    }
                }
            }//.frame(alignment: .leading)
            HStack {
                Text("\(model.daysLeft)")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                Text("days left!")
                .font(.system(size: 18, weight: .medium, design: .rounded))
            }
        }
        .onAppear {
            withAnimation {
                self.percentComplete = CGFloat.random(in: 0...1)
            }
        }
    }
}

struct ProposalRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalRowView(model: ProposalModel.mock)
    }
}
