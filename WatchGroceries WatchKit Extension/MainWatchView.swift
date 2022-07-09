//
//  ContentView.swift
//  WatchGroceries WatchKit Extension
//
//  Created by Shravan Prasanth on 7/7/22.
//

import SwiftUI
import Foundation

struct MainWatchView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @State var isChoosingStore = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(viewModel.chosenStore.storeName, isActive: $isChoosingStore) {
                        ForEach(viewModel.itemReturnables, id: \.self) { store in
                            Button(action: {
                                UserDefaults.standard.setValue("\(store.storeName)", forKey: "store")
                                viewModel.chosenStore = store
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
                    Button(action: {
                        DispatchQueue.main.async {
                            viewModel.loadGroceries()
                            refreshComplications()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }.frame(width: 50)
                }
                if viewModel.itemReturnables.count > 0 {
                    if viewModel.chosenStore.storeName != "Choose Store:" {
                        StoreDetailView(store: viewModel.chosenStore, viewModel: viewModel)
                    }
                    else {
                        Text("Tap 'Choose Store:' to begin.").multilineTextAlignment(.center).padding(.top).padding(.horizontal, 5)
                        Spacer()
                    }
                }
                else {
                    Text("No Groceries! Add more in the iOS App.").multilineTextAlignment(.center).padding(.top).padding(.horizontal, 5)
                    Spacer()
                }
            }.onAppear {
                viewModel.loadGroceries()
                DispatchQueue.global().async {
                    FirebaseExtension().listenForUpdates { bool in
                        if bool {
                            DispatchQueue.main.async {
                                viewModel.loadGroceries()
                                refreshComplications()
                            }
                        }
                    }
                }

            }.navigationTitle("Stores").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MainWatchView_Previews: PreviewProvider {
    static var previews: some View {
        MainWatchView()
    }
}
