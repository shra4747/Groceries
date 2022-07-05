//
//  FirebaseExtension.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/4/22.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import DeviceCheck

class FirebaseExtension {
    func storeData() {
        let items: [ItemModel.Item] = [ItemModel.Item(id: UUID(), name: "Oreos", amount: 1, container: "box", store: "ShopRite"), ItemModel.Item(id: UUID(), name: "Shredded Cheese", amount: 1, container: "bag", store: "ShopRite"), ItemModel.Item(id: UUID(), name: "Lettuce", amount: 1, container: "", store: "Farmer's Market"), ItemModel.Item(id: UUID(), name: "Onions", amount: 1, container: "bag", store: "Farmer's Market")]
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        for item in items {
            print(item)
            ref.child("stores").child(item.store).updateChildValues(["\(item.id)": ["name": item.name, "amount": item.amount, "container": item.container, "store": item.store]])
        }
    }
    
    func readData(completion: @escaping ([ItemModel.ItemReturnable]) -> Void) {
        var groceries: [String: Any] = [:]
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("stores").getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            let groceryData = (snapshot?.value as? Dictionary ?? [:])
            for key in groceryData.keys {
                groceries["\(key)"] = groceryData["\(key)"]
            }
            
            completion(self.formatData(of: groceries))
        })
    }
    
    func formatData(of groceryData: Dictionary<String, Any>) -> [ItemModel.ItemReturnable] {
        var itemReturnable: [ItemModel.ItemReturnable] = []
        
        for store in groceryData.keys {
            
            var groceryItems: [ItemModel.Item] = []
            
            for item in (groceryData[store] as? Dictionary ?? [:]).keys {
                let grocery = (groceryData[store] as? Dictionary ?? [:])[item] as! Dictionary<String, Any>
                let name = grocery["name"] as? String ?? ""
                let amount = grocery["amount"] as? Int ?? 0
                let container = grocery["container"] as? String ?? ""
                let store = grocery["store"] as? String ?? ""
                groceryItems.append(ItemModel.Item(id: UUID(), name: name, amount: amount, container: container, store: store))
            }
            
            itemReturnable.append(ItemModel.ItemReturnable(id: UUID(), storeName: "\(store)", items: groceryItems))
            
        }
        return itemReturnable
    }
}
