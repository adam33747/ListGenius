//
//  AddItemView.swift
//  Mr. Lister
//
//  Created by Adam Hu on 2/15/20.
//  Copyright © 2020 Adam Hu. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
     @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.index, ascending: true)]) var items: FetchedResults<Item>
    @State private var name = ""
    @State private var notes = ""
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter title", text: $name)
                TextField("Additional Notes", text: $notes)
                Section {
                    Button(action: {
                        let newItem = Item(context: self.moc)
                        newItem.name = self.name
                        newItem.notes = self.notes
                        do {
                            try self.moc.save()
                        } catch {
                            print(error)
                        }
                        newItem.index = (self.items.last?.index ?? 0) + 1
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Save")
                        .bold()
                        .foregroundColor(Color.init("Red"))
                    }
                    Button(action: {
                         self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Cancel")
                        .bold()
                            .foregroundColor(Color.init("Red"))
                    }
                }
            }.navigationBarTitle("New Item")
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
