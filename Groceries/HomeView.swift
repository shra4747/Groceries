//
//  ContentView.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/4/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.itemReturnables) { store in
                        Section(store.storeName) {
                            ForEach(store.items, id: \.self) { grocery in
                                var isClicked = false
                                HStack {
                                    HStack {
                                        Button(action: {
                                            isClicked.toggle()
                                        }) {
                                            Image(systemName: isClicked ? "checkmark.circle" : "circle").frame(width: 8, height: 8)
                                        }
                                        Text(grocery.name.capitalized)
                                    }
                                    Spacer()
                                    HStack(spacing: 4) {
                                        Text("\(grocery.amount)").bold()
                                        Text(grocery.container)
                                    }.padding(.trailing, 5)
                                }
                            }
                        }
                    }
                }
                
            }
            .navigationBarTitle("\(viewModel.itemCount) Items")
            .navigationBarItems(trailing: Button(action: {

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
