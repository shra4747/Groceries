//
//  HomeViewModel.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/5/22.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var itemReturnables: [ItemModel.ItemReturnable] = []
    @Published var itemCount = 0
    
    func loadGroceries() {
        self.itemReturnables = []
        self.itemCount = 0
        FirebaseExtension().readData { returnables in
            self.itemReturnables = returnables
            self.getItemCount()
        }
    }
    
    func getItemCount() {
        for store in itemReturnables {
            itemCount += store.items.count
        }
    }
    
    func remove(this grocery: ItemModel.Item, at store: ItemModel.ItemReturnable) {
        
        for (d, r) in self.itemReturnables.enumerated() {
            if r == store {
                for (g, i) in r.items.enumerated() {
                    if i == grocery {
                        self.itemReturnables[d].items.remove(at: g)
                    }
                }
            }
        }
        FirebaseExtension().delete(this: grocery)
        self.itemCount -= 1
    }
}
