//
//  GroceriesApp.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/4/22.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseAuth
import WatchConnectivity



@main
struct GroceriesApp: App {
    
    
    init() {
        FirebaseApp.configure()
    }
    
    @State var appType: AppType = .WAITING
    @State var connectivityManager = WatchConnectivityManager.shared
    var body: some Scene {
        WindowGroup {
            switch appType {
                case .ID_SAVED:
                    HomeView()
                case .NO_ID:
                    StartView(changeView: $appType)
                case .WAITING:
                Text("").onAppear {
                    if let userDefaults = UserDefaults(suiteName: "group.com.shravanprasanth.Groceries") {
                        guard let id = userDefaults.value(forKey: "family_id") as? Int else {
                            appType = .NO_ID
                            return
                        }
                        appType = .ID_SAVED
                        connectivityManager.send(id)
                    }
                    else {
                        appType = .NO_ID
                    }
                }
            }
        }
    }
}

