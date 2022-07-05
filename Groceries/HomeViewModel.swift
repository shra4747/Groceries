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
}
