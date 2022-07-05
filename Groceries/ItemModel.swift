//
//  ItemModel.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/5/22.
//

import Foundation
import UIKit

struct ItemModel: Codable, Hashable, Identifiable {
    
    struct ItemReturnable: Codable, Hashable, Identifiable {
        let id: UUID
        let store: String
        let items: [Item]
    }
    
    let id: UUID
    struct Item: Codable, Hashable, Identifiable {
        let id: UUID
        let name: String
        let amount: Int
        let container: String
        let store: String
    }
}
