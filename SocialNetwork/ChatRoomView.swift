import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatRoomView: View {
    @State private var messages: [ChatMessage] = []
    @State private var newMessage = ""
    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            // Messages List
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(message.sender)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(message.content)
                                    .font(.body)
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                            Spacer()
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGray5))
            .cornerRadius(15)
            .padding()

            // Message Input
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding()
        }
        .navigationTitle("Chat Room")
        .onAppear(perform: fetchMessages)
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
    }

    private func fetchMessages() {
        db.collection("chatrooms")
            .document("general")
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
        db.collection("chatrooms")
            .document("general")
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

