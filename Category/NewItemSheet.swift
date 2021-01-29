//
//  NewItemSheet.swift
//  Category
//
//  Created by Dave Kondris on 29/01/21.
//

import SwiftUI

struct NewItemSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(fetchRequest: Item.fetchRequest(.all)) var categories: FetchedResults<Item>
    
    @State private var name = ""
    
    @State private var errorAlertIsPresented = false
    @State private var errorAlertTitle = ""
    
    let dismissAction: () -> Void
    
    var body: some View {
        
        VStack {
            HStack {
                Button(
                    action: self.dismissAction,
                    label: { Text("Cancel") })
                Spacer()
                addItemButton
            }
            .padding(.vertical)
            Text("Name")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Enter name", text: $name)
            Spacer()
        }
        .padding(.horizontal)
        .alert(
            isPresented: $errorAlertIsPresented,
            content: { Alert(title: Text(errorAlertTitle)) })
    }
    
    private var addItemButton: some View {
        Button(
            action: {
                do {
                    try saveItem()
                } catch {
                    errorAlertTitle = (error as? LocalizedError)?.errorDescription ?? "An error occurred"
                    errorAlertIsPresented = true
                }
            },
            label: { Text("Save") })
    }
    
    private func saveItem() throws {
        do {
            if name.isEmpty {
                throw ValidationError.missingName
            }
            let newItem = Item(context: self.viewContext)
            newItem.name = name
            newItem.timestamp = Date()
            try self.viewContext.save()
            dismissAction()
        } catch {
            errorAlertTitle = (error as? LocalizedError)?.errorDescription ?? "An error occurred"
            errorAlertIsPresented = true
        }
    }
    
}

extension NewItemSheet {
    enum ValidationError: LocalizedError {
        case missingName
        var errorDescription: String? {
            switch self {
                case .missingName:
                    return "Please enter a name for this item."
            }
        }
    }
}

struct NewItemSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewItemSheet(dismissAction: { } )
    }
}

///.all extension
extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}
