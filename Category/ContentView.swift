//
//  ContentView.swift
//  Category
//
//  Created by Dave Kondris on 29/01/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    @State var showingNewItemSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    Text("\(item.name!) = \(item.timestamp!, formatter: itemFormatter)")
                }
                .onDelete(perform: deleteItems)
            }
            .navigationBarItems(trailing:
                                    HStack (spacing: 8) {
                                        EditButton()
                                        addItemButton
                                    }
            )
            .navigationTitle("Items")
        }
    }
    
    private var addItemButton: some View {
        Button(
            action: {
                self.showingNewItemSheet = true
            },
            label: { Image(systemName: "plus.circle.fill").imageScale(.large) })
            .sheet(
                isPresented: $showingNewItemSheet,
                content: { self.newItemSheet })
    }
    
    private var newItemSheet: some View {
        NewItemSheet(
            dismissAction: {
                self.showingNewItemSheet = false
            })
            .environment(\.managedObjectContext, self.viewContext)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
