//
//  InspiresMeDetailView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct InspiresMeDetailView: View {
    
    var model: InspireItem
    
    var body: some View {
        VStack {
            Text("InspiresMeDetailView")
            Text("\(model.title)")
            //Text("\(model.id.uuidString)")
        }
    }
}
