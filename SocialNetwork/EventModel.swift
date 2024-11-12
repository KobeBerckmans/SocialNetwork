import FirebaseFirestore

struct Event: Identifiable, Codable {
    @DocumentID var id: String? // Dit is een optionele DocumentID
    var title: String
    var location: String
    var description: String
    var date: Date
    var organizer: String
    var attendees: [String]
    var isAttending: Bool

    // Voeg de toggleAttendance functie toe
    mutating func toggleAttendance(user: String) {
        if isAttending {
            // Als de gebruiker al aanwezig is, verwijder hem uit de lijst van aanwezigen
            attendees.removeAll { $0 == user }
        } else {
            // Als de gebruiker niet aanwezig is, voeg hem toe aan de lijst van aanwezigen
            attendees.append(user)
        }

        // Zet de isAttending status om
        isAttending.toggle()
    }
}

