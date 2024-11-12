import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var currentUser: String?

    init() {
        // Controleer of de gebruiker is ingelogd
        if let user = Auth.auth().currentUser {
            isSignedIn = true
            currentUser = user.email // of gebruik user.displayName als die beschikbaar is
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error == nil, let user = authResult?.user {
                DispatchQueue.main.async {
                    self?.isSignedIn = true
                    self?.currentUser = user.email // of user.displayName
                }
            } else {
                print("Error signing in: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if error == nil, let user = authResult?.user {
                DispatchQueue.main.async {
                    self?.isSignedIn = true
                    self?.currentUser = user.email // of user.displayName
                }
            } else {
                print("Error signing up: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    func logout() {
           do {
               try Auth.auth().signOut()
               self.currentUser = nil
           } catch {
               print("Error logging out: \(error)")
           }
       }
}
