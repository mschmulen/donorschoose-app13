//
//  RowViews.swift
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
            }
            if model.expirationDate != nil {
                Text("expires on \(model.expirationDate!, formatter: Self.dateDateFormat)")
            }
            Text("PROPOSAL")
        }
    }
}

struct FavoriteTeacherRow: View {
    
    var model: FavoriteTeacher
    
    var body: some View {
        VStack{
            Text("\(model.title ?? "~~~~~")")
            Text("Teacher")
        }
    }
}

struct FavoriteSchoolRow: View {
    
    var model: FavoriteSchool
    
    var body: some View {
        VStack{
            Text("\(model.title ?? "~~~~~")")
            Text("School")
        }
    }
}

struct FavoriteSearchRow: View {
    
    var model: FavoriteSearch
    
    var body: some View {
        VStack{
            Text("\(model.title ?? "~~~~~")")
            Text("Search")
        }
    }
}


