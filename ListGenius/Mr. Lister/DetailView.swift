//
//  DetailView.swift
//  Mr. Lister
//
//  Created by Adam Hu on 2/17/20.
//  Copyright © 2020 Adam Hu. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @State private var showingEditScreen = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
     @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.index, ascending: true)]) var items: FetchedResults<Item>
    @ObservedObject var item: Item
    var body: some View {
        List {
            if self.item.notes == "" {
                Text(" No additional notes")
            } else {
                Text(" " + self.item.notes)
            }
        }
        .navigationBarTitle(self.item.name)
        .navigationBarBackButtonHidden(true)
    .navigationBarItems(leading:
        Button(action: {self.presentationMode.wrappedValue.dismiss()}){
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.init("Red"))
            Text("Back")
            .bold()
                .foregroundColor(Color.init("Red"))
            }
        }
        ,trailing:
        Button(action:{
            self.showingEditScreen.toggle()
        }){
            HStack {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(Color.init("Red"))
            Text("Edit")
            .bold()
                .foregroundColor(Color.init("Red"))
        }
        }
        .sheet(isPresented: $showingEditScreen) {
        EditItemView(item: self.item).environment(\.managedObjectContext, self.moc)
        }
        
        
        )
    }


struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let item = Item(context: moc)
        item.name = "Test title"
        item.notes = "Test notes"
        item.index = 0
        return NavigationView {
            DetailView(item: item)
        }
    }

}
}
