import SwiftUI
import FirebaseFirestore

struct EventListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var events: [Event] = []
    @State private var filterLocation: String = ""
    @State private var showAddEvent = false
    @State private var navigateToChatroom = false // State voor navigatie naar de chatroom
    private let db = Firestore.firestore()

    var filteredEvents: [Event] {
        if filterLocation.isEmpty {
            return events
        } else {
            return events.filter { $0.location.lowercased().contains(filterLocation.lowercased()) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Filter by location", text: $filterLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List {
                    ForEach(filteredEvents) { event in
                        EventRow(event: event) { updatedEvent in
                            if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
                                events[index] = updatedEvent
                                saveEventToFirestore(updatedEvent)
                            }
                        }
                    }
                }

                Spacer() // Push de knoppen naar onderaan het scherm

                HStack {
                    NavigationLink(
                        destination: ChatRoomView(), // Algemene chatroom als bestemming
                        isActive: $navigateToChatroom
                    ) {
                        EmptyView() // Verplicht voor NavigationLink zonder directe inhoud
                    }

                    Button("Go to Chatroom") {
                        navigateToChatroom = true // Activeer navigatie
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Button("Add New Event") {
                        showAddEvent = true
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showAddEvent) {
                    AddEventView(events: $events)
                        .environmentObject(authViewModel)
                }
            }
            .navigationTitle("Events")
            .navigationBarItems(trailing: Button(action: {
                authViewModel.signOut()
            }) {
                Image(systemName: "arrow.backward.circle")
                    .imageScale(.large)
            })
            .onAppear(perform: fetchEventsFromFirestore)
        }
    }

    private func fetchEventsFromFirestore() {
        db.collection("events").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            events = documents.compactMap { document in
                let data = document.data()
                return Event(
                    title: data["title"] as? String ?? "",
                    location: data["location"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                    organizer: data["organizer"] as? String ?? "",
                    attendees: data["attendees"] as? [String] ?? [],
                    isAttending: data["isAttending"] as? Bool ?? false
                )
            }
        }
    }

    private func saveEventToFirestore(_ updatedEvent: Event) {
        let eventID = updatedEvent.id.uuidString
        db.collection("events").document(eventID).setData([
            "title": updatedEvent.title,
            "location": updatedEvent.location,
            "description": updatedEvent.description,
            "date": updatedEvent.date,
            "organizer": updatedEvent.organizer,
            "attendees": updatedEvent.attendees,
            "isAttending": updatedEvent.isAttending
        ]) { error in
            if let error = error {
                print("Error saving event to Firestore: \(error.localizedDescription)")
            } else {
                print("Event successfully saved to Firestore!")
            }
        }
    }
}
