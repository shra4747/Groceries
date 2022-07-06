//
//  AddGroceryView.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/6/22.
//

import SwiftUI
import Introspect

struct AddGroceryView: View {
    
    @State var groceryName = ""
    @State var groceryAmount = 1
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Item Name: ", text: $groceryName)
                    .introspectTextField(customize: { textField in
                        textField.becomeFirstResponder()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 30).padding(.vertical)
                    .shadow(radius: 5)
                HStack {
                    Stepper("Amount: \(groceryAmount)") {
                        groceryAmount += 1
                    } onDecrement: {
                        groceryAmount -= 1
                    }.padding(.horizontal, 100)
                }

            }.navigationTitle("Add Grocery")
        }
    }
}

struct AddGroceryView_Previews: PreviewProvider {
    static var previews: some View {
        AddGroceryView()
    }
}
