//
//  GroceriesApp.swift
//  WatchGroceries WatchKit Extension
//
//  Created by Shravan Prasanth on 7/7/22.
//

import SwiftUI

@main
struct GroceriesApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                MainWatchView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
