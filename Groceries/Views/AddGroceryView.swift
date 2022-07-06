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
    @State var groceryContainer = ""
    @State var groceryStore = ""
    @State var storesList: [String] = []
    
    @State var isChoosingStore = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Form {
                    
                    NavigationLink(groceryStore == "" ? "Choose Store" : groceryStore, isActive: $isChoosingStore) {
                        List {
                            ForEach(storesList, id: \.self) { store in
                                Button(action: {
                                    groceryStore = store
                                    isChoosingStore = false
                                }) {
                                    HStack {
                                        Text(store).foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
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
//
//                    Form {
//                        //                    Picker(groceryStore == "" ? "Store" : groceryStore, selection: $storesList) {
//                        //                        ForEach(storesList, id: \.self) {
//                        //                            Text($0)
//                        //                        }
//                        //                    }
//                    }
                    
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
