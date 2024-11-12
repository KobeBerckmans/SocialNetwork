import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var navigateToLogin: Bool

    var body: some View {
        VStack {
            Button("Log Out") {
                authViewModel.logout()
                navigateToLogin = true // Zet deze naar true om naar het login scherm te navigeren
                presentationMode.wrappedValue.dismiss() // Sluit de instellingen view af
            }
            .padding()
            .foregroundColor(.red)
        }
        .navigationTitle("Settings")
    }
}
    