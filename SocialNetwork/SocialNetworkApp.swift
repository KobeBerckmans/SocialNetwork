//
//  SocialNetworkApp.swift
//  SocialNetwork
//
//  Created by Kobe Berckmans on 30/10/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configureer Firebase
        FirebaseApp.configure()
        
        // Zet App Check uit voor de ontwikkelomgeving
        AppCheck.setAppCheckProviderFactory(nil)
        
        return true
    }
}

@main
struct SocialNetworkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(authViewModel) // Voeg environmentObject toe
            }
        }
    }
}
