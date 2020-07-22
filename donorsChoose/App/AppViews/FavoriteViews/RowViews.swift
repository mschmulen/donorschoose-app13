//
//  FavoriteProposalRow.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct FavoriteProposalRow: View {
    
    var model: FavoriteProposal
    
    static let dateDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading){
            if model.title != nil {
                Text("\(model.title!)")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
            }
            HStack {
                Text("PROPOSAL")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                Spacer()
                if model.expirationDate != nil {
                    Text("expires on \(model.expirationDate!, formatter: Self.dateDateFormat)")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                }
            }
        }
    }
}

struct FavoriteTeacherRow: View {
    
    var model: FavoriteTeacher
    
    var body: some View {
        VStack{
            Text("\(model.title ?? "~")")
                .font(.system(size: 20, weight: .medium, design: .rounded))
            Text("Teacher")
                .font(.system(size: 15, weight: .medium, design: .rounded))
        }
    }
}

struct FavoriteSchoolRow: View {
    
    var model: FavoriteSchool
    
    var body: some View {
        VStack{
            Text("\(model.title ?? "~")")
                .font(.system(size: 20, weight: .medium, design: .rounded))
            Text("School")
                .font(.system(size: 15, weight: .medium, design: .rounded))
        }
    }
}

struct FavoriteSearchRow: View {
    
    var model: FavoriteSearch
    
    var body: some View {
        VStack{
            Text("\(model.title ?? "~")")
                .font(.system(size: 20, weight: .medium, design: .rounded))
            Text("Search")
                .font(.system(size: 15, weight: .medium, design: .rounded))
        }
    }
}


