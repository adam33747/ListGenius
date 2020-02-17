//
//  EditItemView.swift
//  Mr. Lister
//
//  Created by Adam Hu on 2/17/20.
//  Copyright © 2020 Adam Hu. All rights reserved.
//

import SwiftUI
import CoreData

struct EditItemView: View {
    @State var name:String = ""
    @State var notes:String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
     @ObservedObject var item: Item
    var body: some View {
        NavigationView{
            Form {
                TextField("Enter title", text: $name)
                TextField("Additional Notes", text: $notes)
                Section {
                    Button(action: {
                        self.item.name = self.name
                        self.item.notes = self.notes
                           do {
                               try self.moc.save()
                           } catch {
                               print(error)
                           }
                           
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
            }
        }
        .onAppear(perform: {
            self.name = self.item.name
            self.notes = self.item.notes
        })
        .navigationBarTitle("Edit Item")
    }


struct EditItemView_Previews: PreviewProvider {
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
