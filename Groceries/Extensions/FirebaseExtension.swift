//
//  FirebaseExtension.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/4/22.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth


class FirebaseExtension {
    func addNewItem(for name: String, amount: Int, container: String, store: String, id: String) {
        
        let item = ItemModel.Item(id: id, name: name, amount: amount, container: container, store: store)
        
        var ref: DatabaseReference!

        ref = Database.database().reference()

        ref.child("stores").child(item.store).updateChildValues(["\(item.id)": ["name": item.name, "amount": item.amount, "container": item.container, "store": item.store]])
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
                let id = item as! String
                let name = grocery["name"] as? String ?? ""
                let amount = grocery["amount"] as? Int ?? 0
                let container = grocery["container"] as? String ?? ""
                let store = grocery["store"] as? String ?? ""
                groceryItems.append(ItemModel.Item(id: id, name: name, amount: amount, container: container, store: store))
            }
            
            itemReturnable.append(ItemModel.ItemReturnable(id: UUID(), storeName: "\(store)", items: groceryItems))
            
        }
        return itemReturnable
    }
    
    func loadStores(completion: @escaping ([String]) -> Void) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("storeList").getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            let groceryData = (snapshot?.value as? Dictionary ?? [:])
            var storesArray: [String] = []
            for key in groceryData.keys {
                storesArray.append("\(key)")
            }
            completion(storesArray)
        })
    }
    
    func add(store: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("storeList").updateChildValues([store: "\(UUID())"])
    }
    
    
    func delete(this grocery: ItemModel.Item) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        print("\(grocery.store)")
        print("\(grocery.id)")
        ref.child("stores").child("\(grocery.store)").child("\(grocery.id)").removeValue { error, _ in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
    }
}
