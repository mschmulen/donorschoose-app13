//
//  ProposalRowView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ProposalRowView: View {
    
    var model: ProposalModel
    
    @State var percentCompleteProgressValue:Float = 0
    
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

                VStack {
                    Text("% \(model.percentFunded)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text("Funded")
                    .font(.system(size: 13, weight: .light, design: .rounded))
                }.padding()
                
                VStack {
                    Text("\(model.numDonors)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text("Donors")
                    .font(.system(size: 13, weight: .light, design: .rounded))
                }.padding()
            }
            VStack(alignment: .leading) {
                ProgressBar(value: $percentCompleteProgressValue).frame(height: 15)
            }
            HStack {
                Text("\(model.daysLeft)")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                Text("days left!")
                .font(.system(size: 18, weight: .medium, design: .rounded))
            }
        }
        .onAppear {
            self.startProgressBar(percentFunded: self.model.percentFunded)
        }
    }
    
    func startProgressBar(percentFunded: Int ) {
        self.percentCompleteProgressValue = 0.0
        for _ in 0...percentFunded {
            self.percentCompleteProgressValue += 0.01
        }
    }
    
}

struct ProposalRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalRowView(model: ProposalModel.mock)
    }
}
