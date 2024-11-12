//
//  ContentView.swift
//  SocialNetwork
//
//  Created by Kobe Berckmans on 30/10/2024.
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if authViewModel.isSignedIn {
            EventListView()
                .environmentObject(authViewModel) // Zorg dat AuthViewModel wordt doorgegeven
        } else {
            NavigationView {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
