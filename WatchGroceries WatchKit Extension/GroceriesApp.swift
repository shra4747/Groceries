//
//  GroceriesApp.swift
//  WatchGroceries WatchKit Extension
//
//  Created by Shravan Prasanth on 7/7/22.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth

@main
struct GroceriesApp: App {
    
    init() {
        FirebaseApp.configure()
        refreshComplications()
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                MainWatchView()
            }
        }
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
