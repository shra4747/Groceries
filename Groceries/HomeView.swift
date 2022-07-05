//
//  ContentView.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/4/22.
//

import SwiftUI

struct HomeView: View {
    
    @State var items: [ItemModel.Item] = [ItemModel.Item(id: UUID(), name: "grapes", amount: 1, container: "box", store: "ShopRite"), ItemModel.Item(id: UUID(), name: "oranges", amount: 1, container: "box", store: "Farmer's Market")]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section("Shop Rite") {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Text(item.name.capitalized)
                                Spacer()
                                HStack(spacing: 4) {
                                    Text("\(item.amount)").bold()
                                    Text(item.container)
                                }.padding(.trailing, 5)
                            }
                        }
                    }
                    Section("Farmer's Market") {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Text(item.name.capitalized)
                                Spacer()
                                HStack(spacing: 4) {
                                    Text("\(item.amount)").bold()
                                    Text(item.container)
                                }.padding(.trailing, 5)
                            }
                        }
                    }
                }
                
            }
            .navigationBarTitle("\(items.count) Items")
            .navigationBarItems(trailing: Button(action: {

            }) {
                Text("+").font(.largeTitle)
            })
        }
        .onAppear {
            FirebaseExtension().readData { returnable in
                for store in returnable {
                    print(store.store)
                    print(store.items)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
