import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var currentUser: String?

    init() {
        forceSignOut()
    }

    func forceSignOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
        isSignedIn = false
        currentUser = nil
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error == nil, let user = authResult?.user {
                DispatchQueue.main.async {
                    self?.isSignedIn = true
                    self?.currentUser = user.email
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
                    self?.currentUser = user.email
                }
            } else {
                print("Error signing up: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isSignedIn = false
            self.currentUser = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
