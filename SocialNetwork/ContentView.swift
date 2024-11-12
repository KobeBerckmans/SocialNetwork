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
        if authViewModel.isSignedIn {
            EventListView()
        } else {
            NavigationView {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel()) // Preview werkt nu met AuthViewModel
}

