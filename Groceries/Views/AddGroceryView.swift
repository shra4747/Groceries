//
//  AddGroceryView.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/6/22.
//

import SwiftUI
import Introspect

struct AddGroceryView: View {
    let callback: (String, Int, String, String, String) -> ()
    
    @Environment(\.presentationMode) var presentationMode

    @State var groceryName = ""
    @State var groceryAmount = 1
    @State var groceryContainer = ""
    @State var groceryStore = ""
    @State var storesList: [String] = []
    
    @State var isChoosingStore = false
    @State var newStore = ""
    
    @State var isAddingMultiple = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Form {
                    NavigationLink(groceryStore == "" ? "Choose Store" : groceryStore, isActive: $isChoosingStore) {
                        List {
                            
                            HStack {
                                TextField("Add New Store", text: $newStore).disableAutocorrection(true)
                                Button(action: {
                                    FirebaseExtension().add(store: newStore)
                                    groceryStore = newStore
                                    newStore = ""
                                    isChoosingStore = false
                                }) {
                                    Text("Add")
                                }
                            }
                            
                            ForEach(storesList, id: \.self) { store in
                                Button(action: {
                                    groceryStore = store
                                    isChoosingStore = false
                                }) {
                                    HStack {
                                        Text(store).foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.left")
                                            .scaleEffect(0.8)
                                            .foregroundColor(Color(.lightGray))
                                    }
                                }
                            }
                        }.onAppear {
                            FirebaseExtension().loadStores { stores in
                                storesList = stores
                            }
                        }
                    }
                    
                    TextField("Item Name: ", text: $groceryName)
                        .introspectTextField(customize: { textField in
                            textField.becomeFirstResponder()
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical)
                        .shadow(radius: 5)
                    HStack {
                        Stepper("Amount: \(groceryAmount)") {
                            groceryAmount += 1
                        } onDecrement: {
                            groceryAmount -= 1
                        }.padding(.horizontal, 50).padding(.vertical)
                    }
                    
                    HStack {
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).foregroundColor(groceryContainer == "" ? .green : .white).animation(.easeInOut, value: 1).shadow(radius: 5)
                                Text("#️⃣")
                            }.frame(height: 80).onTapGesture { groceryContainer = "" }
                            Text("Single")
                        }
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).foregroundColor(groceryContainer == "box" ? .green : .white).animation(.easeInOut, value: 1).shadow(radius: 5)
                                Text("📦")
                            }.frame(height: 80).onTapGesture { groceryContainer = "box" }
                            Text("Box")
                        }
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).foregroundColor(groceryContainer == "bag" ? .green : .white).animation(.easeInOut, value: 1).shadow(radius: 5)
                                Text("🛍️")
                            }.frame(height: 80).onTapGesture { groceryContainer = "bag" }
                            Text("Bag")
                        }
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).foregroundColor(groceryContainer == "can" ? .green : .white).animation(.easeInOut, value: 1).shadow(radius: 5)
                                Text("🥫")
                            }.frame(height: 80).onTapGesture { groceryContainer = "can" }
                            Text("Can")
                        }
                    }.padding(.vertical)
                }
                Spacer()
            }.navigationTitle("Add Grocery")
                .navigationBarItems(
                    leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        if isAddingMultiple {
                            Text("Done")
                        }
                    },
            trailing:
                Button(action: {
                    let id = UUID().uuidString
                    if groceryName.isEmpty || groceryStore.isEmpty {
                        return
                    }
                    
                    
                    
                    if isAddingMultiple {
                        FirebaseExtension().addNewItem(for: groceryName, amount: groceryAmount, container: groceryContainer, store: groceryStore, id: id)
                    }
                    else {
                        FirebaseExtension().addNewItem(for: groceryName, amount: groceryAmount, container: groceryContainer, store: groceryStore, id: id)
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    self.callback(groceryName, groceryAmount, groceryContainer, groceryStore, id)
                    groceryName = ""
                    groceryAmount = 1
                    groceryContainer = ""
                }) {
                    Image(systemName: "plus")
                })
        }
    }
}
