import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatRoomView: View {
    @State private var messages: [ChatMessage] = []
    @State private var newMessage = ""
    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            List(messages) { message in
                VStack(alignment: .leading) {
                    Text(message.sender)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text(message.content)
                        .font(.body)
                }
            }

            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    sendMessage()
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Chat Room")
        .onAppear(perform: fetchMessages)
    }

    private func fetchMessages() {
        db.collection("chatrooms") // Vaste collectie voor de algemene chat
            .document("general") // Document-ID voor de algemene chat
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                messages = documents.compactMap { document in
                    let data = document.data()
                    return ChatMessage(
                        content: data["content"] as? String ?? "",
                        sender: data["sender"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    )
                }
            }
    }

    private func sendMessage() {
        guard let sender = Auth.auth().currentUser?.email else { return }
        let messageData: [String: Any] = [
            "content": newMessage,
            "sender": sender,
            "timestamp": Timestamp()
        ]
        db.collection("chatrooms") // Vaste collectie
            .document("general") // Document-ID voor de algemene chat
            .collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    newMessage = ""
                }
            }
    }
}

