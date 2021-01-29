//
//  ItemProfile.swift
//  Category
//
//  Created by Dave Kondris on 29/01/21.
//

import SwiftUI

struct ItemProfile: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var item: Item
    
    @State private var isEditing = false
    
    @State private var errorAlertIsPresented = false
    @State private var errorAlertTitle = ""
    var body: some View {
    
        VStack{
            if !isEditing {
                Text("\(item.name) = \(item.timestamp ?? Date(), formatter: itemFormatter)")
            } else {
                TextField("Name", text: $item.name)
            }
        }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(isEditing ? true : false)
            .navigationBarItems(leading:
                                    Button (action: {
                                        viewContext.refresh(item, mergeChanges: false)
                                        withAnimation {
                                            self.isEditing = false
                                        }
                                    }, label: {
                                        Text(isEditing ? "Cancel" : "")
                                    }),
                                trailing:
                                    Button (action: {
                                        if isEditing { saveItem() }
                                        withAnimation {
                                            if !errorAlertIsPresented {
                                                self.isEditing.toggle()
                                            }
                                        }
                                    }, label: {
                                        Text(!isEditing ? "Edit" : "Done")
                                    })
            )
            .alert(
                isPresented: $errorAlertIsPresented,
                content: { Alert(title: Text(errorAlertTitle)) })
        
    }
    
    private func saveItem() {
        do {
            if item.name.isEmpty {
                throw ValidationError.missingName
            }
//            item.timestamp = Date()
            try viewContext.save()
        } catch {
            errorAlertTitle = (error as? LocalizedError)?.errorDescription ?? "An error occurred"
            errorAlertIsPresented = true
        }
    }
}

extension ItemProfile {
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



//struct ItemProfile_Previews: PreviewProvider {
//static var previews: some View {
//
//    ItemProfile(item: item)
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//
//
//    }
//}
