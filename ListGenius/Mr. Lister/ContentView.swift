//
//  ContentView.swift
//  Mr. Lister
//
//  Created by Adam Hu on 2/15/20.
//  Copyright © 2020 Adam Hu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.index, ascending: true)]) var items: FetchedResults<Item>
    @Environment(\.managedObjectContext) var moc
    @State private var showingAddScreen = false
    @State var isEditing = false
    func moveItem(indexSet: IndexSet, destination: Int) {
        let source = indexSet.first!
        
        if source < destination {
            var startIndex = source + 1
            let endIndex = destination - 1
            var startOrder = items[source].index
            while startIndex <= endIndex {
                items[startIndex].index = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            
            items[source].index = startOrder
            
        } else if destination < source {
            var startIndex = destination
            let endIndex = source - 1
            var startOrder = items[destination].index + 1
            let newOrder = items[destination].index
            while startIndex <= endIndex {
                items[startIndex].index = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            items[source].index = newOrder
        }
        do {
        try self.moc.save()
                           } catch {
                               print(error)
                           }
    }
    func deleteItem(indexSet: IndexSet) {
        let source = indexSet.first!
        let item = items[source]
        moc.delete(item)
         do {
            try self.moc.save()
                               } catch {
                                   print(error)
                               }
    }
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(destination: DetailView(item: item)){
                        Text("\(item.name)")
                        }
                    }.onDelete(perform: deleteItem)
                .onMove(perform: moveItem)
                }
                
            }
            .navigationBarTitle("My List")
                .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
            .navigationBarItems(leading: Button(action: { self.isEditing.toggle() }){
                HStack {
                    Image(systemName: isEditing ? "checkmark.circle" : "minus.circle")
                        .foregroundColor(Color.init("Red"))
                Text(isEditing ? "Done" : "Edit")
                    .font(.system(size: 17, design: .rounded)).bold()
                    .foregroundColor(Color.init("Red"))
                }
            },
            
                trailing:
         Button(action: {self.showingAddScreen.toggle()}) {
            HStack {
                Image(systemName: "plus.circle")
                    .foregroundColor(Color.init("Red"))
             Text("Add ").font(.system(size: 17, design: .rounded)).bold()
                .foregroundColor(Color.init("Red"))
         }
         }
         .sheet(isPresented: $showingAddScreen) {
             AddItemView().environment(\.managedObjectContext, self.moc)
             })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
