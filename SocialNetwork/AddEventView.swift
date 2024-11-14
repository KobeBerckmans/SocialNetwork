import SwiftUI
import FirebaseFirestore

struct AddEventView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var events: [Event]

    @State private var title = ""
    @State private var location = ""
    @State private var description = ""
    @State private var date = Date()
    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            TextField("Event Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Location", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Date", selection: $date, displayedComponents: .date)
                .padding()

            Button("Add Event") {
                let newEvent = Event(
                    title: title,
                    location: location,
                    description: description,
                    date: date,
                    organizer: authViewModel.currentUser ?? "Unknown",
                    attendees: [],
                    isAttending: false
                )
                events.append(newEvent)
                saveEventToFirestore(newEvent)
            }
            .padding()
        }
        .navigationTitle("Add New Event")
    }

    // Functie om het nieuwe evenement op te slaan in Firestore
    private func saveEventToFirestore(_ newEvent: Event) {
        let eventID = newEvent.id.uuidString
        db.collection("events").document(eventID).setData([
            "title": newEvent.title,
            "location": newEvent.location,
            "description": newEvent.description,
            "date": newEvent.date,
            "organizer": newEvent.organizer,
            "attendees": newEvent.attendees,
            "isAttending": newEvent.isAttending
        ]) { error in
            if let error = error {
                print("Error saving new event to Firestore: \(error.localizedDescription)")
            } else {
                print("New event successfully saved to Firestore!")
            }
        }
    }
}
