//
//  ContentView.swift
//  SocialNetwork
//
//  Created by Kobe Berckmans on 30/10/2024.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isSignedIn {
                NavigationView {
                    EventListView()
                }
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
