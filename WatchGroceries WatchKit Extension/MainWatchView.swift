//
//  ContentView.swift
//  WatchGroceries WatchKit Extension
//
//  Created by Shravan Prasanth on 7/7/22.
//

import SwiftUI

struct MainWatchView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.itemReturnables, id: \.self) { store in
                        NavigationLink(store.storeName) {
                            List {
                                ForEach(store.items, id: \.self) { grocery in
                                    HStack {
                                        CheckmarkButton(id: "\(grocery.id)", size: 14) { _, _ in
                                            viewModel.remove(this: grocery, at: store)
                                        }.foregroundColor(Color.white)
                                        Text(grocery.name.capitalized).foregroundColor(.white)
                                    }
                                    Spacer()
                                    HStack(spacing: 4) {
                                        Text("\(grocery.amount)").bold().foregroundColor(.white)
                                        Text(grocery.container).foregroundColor(.white)
                                    }.padding(.trailing, 5)
                                }
                            }
                        }
                    }
                }
            }.onAppear {
                viewModel.loadGroceries()
            }
        }
    }
}

struct MainWatchView_Previews: PreviewProvider {
    static var previews: some View {
        MainWatchView()
    }
}
