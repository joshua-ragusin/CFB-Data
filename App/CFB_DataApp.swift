//
//  CFB_DataApp.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI

@main
struct CFB_DataApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    boostrapAPIKey()
                    await APIConfig.shared.configure()
                }
        }
    }
    
    func boostrapAPIKey() {
        guard KeychainHelper.load() == nil else { return }
        if let key = Bundle.main.infoDictionary?["CFBDApiKey"] as? String {
            KeychainHelper.save(key)
        }
    }
}
