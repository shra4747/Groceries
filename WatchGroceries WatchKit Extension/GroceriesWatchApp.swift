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
import WatchConnectivity


@main
struct GroceriesApp: App {
    
    
    init() {
        FirebaseApp.configure()
        refreshComplications()
    }
    
    @State var connectivityManager = WatchConnectivityManager.shared
    @State var appType: AppType = .WAITING
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ZStack {
                switch appType {
                case .ID_SAVED:
                    MainWatchView()
                default:
                    VStack {
                        Image(systemName: "iphone").resizable().frame(width: 15, height: 25)
                        Text("Close and Reopen iOS App or Click 'Connect Watch' in Settings!").multilineTextAlignment(.center)
                        Button(action: {
                            if let family_id = UserDefaults(suiteName: "group.com.shravanprasanth.Groceries")?.value(forKey: "family_id") as? Int {
                                FirebaseExtension().checkFamily(familyID: family_id) { isFamily in
                                    if isFamily {
                                        appType = .ID_SAVED
                                    }
                                }
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }.onAppear {
                
                UserDefaults(suiteName: "group.com.shravanprasanth.Groceries")?.setValue(0, forKey: "family_id")
                
                if let family_id = UserDefaults(suiteName: "group.com.shravanprasanth.Groceries")?.value(forKey: "family_id") as? Int {
                    FirebaseExtension().checkFamily(familyID: family_id) { isFamily in
                        if isFamily {
                            appType = .ID_SAVED
                        }
                    }
                }
            }
        }
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
