//
//  StoreDetailView.swift
//  WatchGroceries WatchKit Extension
//
//  Created by Shravan Prasanth on 7/7/22.
//

import SwiftUI
import ClockKit

struct StoreDetailView: View {
    
    @State var store: ItemModel.ItemReturnable
    @State var viewModel: HomeViewModel
    
    var body: some View {
        List {
            ForEach(store.items, id: \.self) { grocery in
                HStack {
                    HStack {
                        CheckmarkButton(id: "\(grocery.id)", size: 14) { _, _ in
                            refreshComplications()
                            if let index = store.items.firstIndex(of: grocery) {
                                store.items.remove(at: index)
                            }
                            viewModel.remove(this: grocery, at: store)
                            
                            if store.items.count == 0 {
                                if viewModel.itemReturnables.count > 0 {
                                    for item in viewModel.itemReturnables {
                                        if !item.items.isEmpty && item.storeName != store.storeName {
                                            viewModel.chosenStore = item
                                            UserDefaults.standard.setValue("\(item.storeName)", forKey: "store")
                                            break
                                        }
                                    }
                                    
                                    viewModel.chosenStore = ItemModel.ItemReturnable(id: UUID(), storeName: "Choose Store:", items: [])
                                    UserDefaults.standard.setValue("", forKey: "store")
                                }
                            }
                        }.foregroundColor(Color.white)
                        Text(grocery.name.capitalized).fontWeight(.semibold).foregroundColor(.white)
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


