//
//  ProgressBarView.swift
//  donorsChoose
//
//  Created by Matthew Schmulen on 7/23/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        // ProgressBar(value: .constant(Float.random(in: 0...1)))
        
        Group {
            ProgressBar(value: .constant(0.1))
                       .previewLayout(.fixed(width: 400, height: 20))
                       .border(Color.green)
                       .environment(\.colorScheme, .dark)
            
            ProgressBar(value: .constant(0.50))
                       .previewLayout(.fixed(width: 400, height: 20))
                       .border(Color.green)
                       .environment(\.colorScheme, .dark)
            
            ProgressBar(value: .constant(0.90))
                       .previewLayout(.fixed(width: 400, height: 20))
                       .border(Color.green)
                       .environment(\.colorScheme, .dark)
            
            ProgressBar(value: .constant(0.100))
                       .previewLayout(.fixed(width: 400, height: 20))
                       .border(Color.green)
                       .environment(\.colorScheme, .dark)
        }
        
    }
}


//                GeometryReader { geometry in
//                    ZStack {
//                        Rectangle()
//                            .frame(width: geometry.size.width, height: 5)
//                            .foregroundColor(.gray)
//                        Rectangle()
//                            .frame(width: geometry.size.width * self.percentComplete, height: 3, alignment: .leading)
//                            .foregroundColor(.green)
//                    }
//                }
