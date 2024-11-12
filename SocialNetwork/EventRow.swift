import SwiftUI

struct EventRow: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var event: Event
    var onEventUpdated: (Event) -> Void
    
    @State private var isAttending = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.headline)
            Text(event.location)
                .font(.subheadline)
            Text(event.description)
                .font(.body)
            
            // Gebruik de aangepaste DateFormatter voor een korte datumweergave
            Text("Date: \(event.date, formatter: DateFormatter.shortDateFormatter)")
                .font(.footnote)
                .padding(.bottom, 5)
            
            // Toont de aanwezigen
            if !event.attendees.isEmpty {
                Text("Attendees: \(event.attendees.joined(separator: ", "))")
                    .font(.subheadline)
                    .padding(.bottom, 5)
            }

            Button(action: {
                isAttending.toggle()
                updateAttendance()
            }) {
                Text(isAttending ? "I am attending" : "I am not attending")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    func updateAttendance() {
        guard let currentUser = authViewModel.currentUser else { return }
        
        var updatedEvent = event
        
        if isAttending {
            // Voeg de gebruiker toe aan de lijst van aanwezigen
            updatedEvent.attendees.append(currentUser)
        } else {
            // Verwijder de gebruiker uit de lijst van aanwezigen
            updatedEvent.attendees.removeAll { $0 == currentUser }
        }
        
        // Sla de bijgewerkte event op in Firestore
        EventService().updateEvent(event: updatedEvent)
        
        // Zorg ervoor dat de list van evenementen ook bijgewerkt wordt
        onEventUpdated(updatedEvent)
    }
}

extension DateFormatter {
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}
