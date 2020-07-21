//
//  InspiresMeView.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct InspireItem: Identifiable {
    let id = UUID()
    let title: String
}

struct LegacyInspiresMeView: View {
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var appState: AppState
    
    var setTabIndexCallback: ((TopTabView.TabViewIndex) ->())?
    
    @State private var items: [InspireItem] = (0..<5).map { InspireItem(title: "Item #\($0)") }
    //@State private var items: [InspireItem] = []
    private static var count = 5
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationView {
            VStack{
                Text("InspiresMeView")
                List {
                    ForEach(items) { item in
                        NavigationLink(destination:InspiresMeDetailView(model:item)) {
                            Text(item.title)
                        }
                    }
                    .onDelete(perform: onDelete)
                    .onMove(perform: onMove)
                }
                .navigationBarTitle("InspiresMe")
                .navigationBarItems(leading: EditButton(), trailing: addButton)
                .environment(\.editMode, $editMode)
            }
        }
    }
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }
    }
    
    func onAdd() {
        items.append(InspireItem(title: "Item #\(Self.count)"))
        Self.count += 1
    }
    
    private func onDelete(offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    
    private func onMove(source: IndexSet, destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

// references https://www.vadimbulavin.com/add-edit-move-and-drag-and-drop-in-swiftui-list/
