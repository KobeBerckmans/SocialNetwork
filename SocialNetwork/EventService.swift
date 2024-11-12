import FirebaseFirestore

class EventService: ObservableObject {
    private var db = Firestore.firestore()

    // Markeer 'events' als @Published zodat het automatisch geüpdatet wordt in de views
    @Published var events: [Event] = []

    init() {
        fetchEvents()
    }

    // Haal de evenementen op met een snapshot listener zodat het automatisch wordt bijgewerkt
    func fetchEvents() {
        db.collection("events")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error getting events: \(error)")
                    return
                }
                
                // Zet de evenementen in de gepubliceerde array
                self.events = snapshot?.documents.compactMap { document in
                    try? document.data(as: Event.self)
                } ?? []
            }
    }

    // Voeg een nieuw event toe aan Firestore
    func addEvent(event: Event) {
        do {
            let _ = try db.collection("events").addDocument(from: event)
        } catch {
            print("Error adding event: \(error)")
        }
    }

    // Werk een event bij in Firestore
    func updateEvent(event: Event) {
        guard let eventId = event.id else { return }

        do {
            try db.collection("events").document(eventId).setData(from: event)
        } catch {
            print("Error updating event: \(error)")
        }
    }
}
