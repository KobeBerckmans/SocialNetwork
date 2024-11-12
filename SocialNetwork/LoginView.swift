import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Login") {
                authViewModel.signIn(email: email, password: password)
            }
            .padding()

            NavigationLink("Create Account", destination: RegisterView().environmentObject(authViewModel)) // Voeg environmentObject toe
                .padding()
        }
        .navigationTitle("Login")
    }
}
