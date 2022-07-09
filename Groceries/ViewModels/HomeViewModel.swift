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
    @Published var chosenStore: ItemModel.ItemReturnable = ItemModel.ItemReturnable(id: UUID(), storeName: "Choose Store:", items: [])
    
    func loadGroceries() {
        self.itemReturnables = []
        self.itemCount = 0
        FirebaseExtension().readData { returnables in
            self.itemReturnables = returnables
            self.getItemCount()
            self.sort()
            
            for returnable in self.itemReturnables {
                if returnable.storeName == self.chosenStore.storeName {
                    self.chosenStore = returnable
                }
            }
        }
    }
    
    
    
    
    func sort() {
        self.itemReturnables = self.itemReturnables.sorted(by: { $0.storeName.lowercased() < $1.storeName.lowercased()})
        
        for (i,_) in itemReturnables.enumerated() {
            self.itemReturnables[i].items = self.itemReturnables[i].items.sorted(by: {$0.name.lowercased() < $1.name.lowercased() })
        }
    }
    
    
    func getItemCount() {
        FirebaseExtension().getItemCount { count, _  in
            self.itemCount = count
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
        self.sort()
    }
}
