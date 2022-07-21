//
//  WatchConnectivityExtension.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/21/22.
//

import Foundation
import WatchConnectivity

final class WatchConnectivityManager: NSObject {
    static let shared = WatchConnectivityManager()
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    private let kMessageKey = "family_id"
    
    func send(_ message: Int) {
        guard WCSession.default.activationState == .activated else {
            return
        }
        
#if os(iOS)
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
#endif
        
        WCSession.default.sendMessage([kMessageKey : message], replyHandler: nil) { error in
            print("Cannot send message: \(String(describing: error))")
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let id = message[kMessageKey] as? Int {
            UserDefaults(suiteName: "group.com.shravanprasanth.Groceries")?.setValue(id, forKey: "family_id")
        }
        
        print(message)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif
}

enum AppType {
    case ID_SAVED
    case NO_ID
    case WAITING
}
