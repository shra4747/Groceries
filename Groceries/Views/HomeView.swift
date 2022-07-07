//
//  ContentView.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/4/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @State var addingNewGrocery = false
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.itemReturnables) { store in
                        if store.items.count > 0 {
                            Section(store.storeName) {
                                ForEach(store.items, id: \.self) { grocery in
                                    HStack {
                                        HStack {
                                            CheckmarkButton(id: "\(grocery.id)", size: 14) { _, _ in
                                                viewModel.remove(this: grocery, at: store)
                                            }.foregroundColor(Color.black)
                                            Text(grocery.name.capitalized)
                                        }
                                        Spacer()
                                        HStack(spacing: 4) {
                                            Text("\(grocery.amount)").bold()
                                            Text(grocery.container)
                                        }.padding(.trailing, 5)
                                    }.swipeActions(edge: .trailing) {
                                        Button {
                                            viewModel.remove(this: grocery, at: store)
                                        } label: {
                                            Label("", systemImage: "delete.forward")
                                        }
                                        .tint(.red)
                                    }.animation(Animation.easeInOut(duration: 0.5), value: 1)
                                }
                            }
                        }
                    }
                }
                
            }
            .sheet(isPresented: $addingNewGrocery, content: {
                AddGroceryView(callback: { name, amount, container, store, id in
                    for (d, r) in viewModel.itemReturnables.enumerated() {
                        if r.storeName == store {
                            viewModel.itemReturnables[d].items.append(ItemModel.Item(id: id, name: name, amount: amount, container: container, store: store))
                        }
                    }
                })
            })
            .navigationBarTitle("\(viewModel.itemCount) Items")
            .navigationBarItems(trailing: Button(action: {
                addingNewGrocery.toggle()
            }) {
                Text("+").font(.largeTitle)
            })
        }
        .onAppear {
            viewModel.loadGroceries()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
