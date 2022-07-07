//
//  StoreDetailView.swift
//  WatchGroceries WatchKit Extension
//
//  Created by Shravan Prasanth on 7/7/22.
//

import SwiftUI

struct StoreDetailView: View {
    
    @State var store: ItemModel.ItemReturnable
    @State var viewModel: HomeViewModel
    
    var body: some View {
        List {
            ForEach(store.items, id: \.self) { grocery in
                HStack {
                    HStack {
                        CheckmarkButton(id: "\(grocery.id)", size: 14) { _, _ in
                            viewModel.remove(this: grocery, at: store)
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

