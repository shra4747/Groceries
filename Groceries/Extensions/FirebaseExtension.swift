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
import WatchConnectivity

class FirebaseExtension {
    
    func listenForUpdates(completion: @escaping (Bool) -> Void) {
        var familyId: Int = 0
        if let userDefaults = UserDefaults(suiteName: "group.com.shravanprasanth.Groceries") {
            guard let FI = userDefaults.value(forKey: "family_id") as? Int else {
                return
            }
            familyId = FI
        }
        else {
            return
        }
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        ref.child("families").child("\(familyId)").child("stores").observe(DataEventType.value) { _ in
            completion(true)
        }
    }
    
    func addNewItem(for name: String, amount: Int, container: String, store: String, id: String) {
        
        var familyId: Int = 0
        if let userDefaults = UserDefaults(suiteName: "group.com.shravanprasanth.Groceries") {
            guard let FI = userDefaults.value(forKey: "family_id") as? Int else {
                return
            }
            familyId = FI
        }
        else {
            return
        }
        
        let item = ItemModel.Item(id: id, name: name, amount: amount, container: container, store: store)
        
        var ref: DatabaseReference!

        ref = Database.database().reference()

        ref.child("families").child("\(familyId)").child("stores").child(item.store).updateChildValues(["\(item.id)": ["name": item.name, "amount": item.amount, "container": item.container, "store": item.store]])
    }
    
    func getItemCount(completion: @escaping (Int, ItemModel.ItemReturnable) -> Void) {
        var itemCount = 0
        var r: ItemModel.ItemReturnable = ItemModel.ItemReturnable(id: UUID(), storeName: "", items: [])
        var didR = false
        
        self.readData { returnables in
            
            var store: String
            if let currentStore = UserDefaults.standard.value(forKey: "store") as? String {
                store = currentStore
            }
            else {
                store = ""
            }
            
            for item in returnables {
                itemCount += item.items.count
                if item.storeName == store {
                    r = item
                    didR = true
                }
            }
            
            if !didR && returnables.count > 0 {
                r = returnables[0]
            }
            completion(itemCount, r)
        }
    }
    
    func readData(completion: @escaping ([ItemModel.ItemReturnable]) -> Void) {
        
        var familyId: Int = 0
        if let userDefaults = UserDefaults(suiteName: "group.com.shravanprasanth.Groceries") {
            guard let FI = userDefaults.value(forKey: "family_id") as? Int else {
                return
            }
            familyId = FI
        }
        else {
            return
        }
        
        var groceries: [String: Any] = [:]
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("families").child("\(familyId)").child("stores").getData(completion: { error, snapshot in
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
                var container = grocery["container"] as? String ?? ""
                container = modifyPlural(for: container, itemCount: amount)
                let store = grocery["store"] as? String ?? ""
                groceryItems.append(ItemModel.Item(id: id, name: name, amount: amount, container: container, store: store))
            }
            
            itemReturnable.append(ItemModel.ItemReturnable(id: UUID(), storeName: "\(store)", items: groceryItems))
            
        }
        return itemReturnable
    }
    
    func modifyPlural(for containerString: String, itemCount: Int) -> String {
        if itemCount > 1 {
            // Box, Can, Bag, Singular
            if containerString == "box" {
                return "boxes"
            }
            else if containerString == "can" {
                return "cans"
            }
            else if containerString == "bag" {
                return "bags"
            }
        }
        
        
        return containerString
    }
    
    func loadStores(completion: @escaping ([String]) -> Void) {
        
        var familyId: Int = 0
        if let userDefaults = UserDefaults(suiteName: "group.com.shravanprasanth.Groceries") {
            guard let FI = userDefaults.value(forKey: "family_id") as? Int else {
                return
            }
            familyId = FI
        }
        else {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("families").child("\(familyId)").child("storeList").getData(completion: { error, snapshot in
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
        
        var familyId: Int = 0
        if let userDefaults = UserDefaults(suiteName: "group.com.shravanprasanth.Groceries") {
            guard let FI = userDefaults.value(forKey: "family_id") as? Int else {
                return
            }
            familyId = FI
        }
        else {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("families").child("\(familyId)").child("storeList").updateChildValues([store: "\(UUID())"])
    }
    
    
    func delete(this grocery: ItemModel.Item) {
        
        var familyId: Int = 0
        if let userDefaults = UserDefaults(suiteName: "group.com.shravanprasanth.Groceries") {
            guard let FI = userDefaults.value(forKey: "family_id") as? Int else {
                return
            }
            familyId = FI
        }
        else {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("families").child("\(familyId)").child("stores").child("\(grocery.store)").child("\(grocery.id)").removeValue { error, _ in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func addFamily(familyName: String, familyID: Int) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("familyList").updateChildValues([familyName: familyID])
    }
    
    func checkFamily(familyID: Int, completion: @escaping (Bool) -> Void) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("familyList").getData(completion: { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            let familiesData = (snapshot?.value as? Dictionary ?? [:])
            
            for key in familiesData.keys {
                if (familiesData[key] as? Int ?? 0) == familyID {
                    completion(true)
                    return
                }
            }
            completion(false)
            return
        })
    }
    
}
