//
//  ContentView.swift
//  WatchGroceries WatchKit Extension
//
//  Created by Shravan Prasanth on 7/7/22.
//

import SwiftUI

struct MainWatchView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @State var chosenStore: ItemModel.ItemReturnable = ItemModel.ItemReturnable(id: UUID(), storeName: "Choose Store:", items: [])
    @State var isChoosingStore = false
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(chosenStore.storeName, isActive: $isChoosingStore) {
                    ForEach(viewModel.itemReturnables, id: \.self) { store in
                        Button(action: {
                            chosenStore = store
                            isChoosingStore.toggle()
                        }) {
                            HStack {
                                Text(store.storeName)
                                Spacer()
                                Image(systemName: "chevron.left")
                            }
                        }
                    }
                    Spacer()
                }
                if viewModel.itemReturnables.count > 0 {
                    StoreDetailView(store: chosenStore, viewModel: viewModel)
                }
                Spacer()
            }.onAppear {
                viewModel.loadGroceries()
            }.navigationTitle("Stores").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MainWatchView_Previews: PreviewProvider {
    static var previews: some View {
        MainWatchView()
    }
}
