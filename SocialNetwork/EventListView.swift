import SwiftUI

struct EventListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var events: [Event] = [
        Event(title: "Concert", location: "Antwerp", description: "A night of amazing music", date: Date(), organizer: "Alice", attendees: [], isAttending: false),
        Event(title: "Art Exhibit", location: "Brussels", description: "Showcasing local artists", date: Date(), organizer: "Bob", attendees: [], isAttending: false)
    ]
    
    @State private var filterLocation: String = ""
    @State private var showAddEvent = false

    var filteredEvents: [Event] {
        if filterLocation.isEmpty {
            return events
        } else {
            return events.filter { $0.location.lowercased().contains(filterLocation.lowercased()) }
        }
    }

    var body: some View {
        VStack {
            TextField("Filter by location", text: $filterLocation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            List {
                ForEach(filteredEvents) { event in
                    EventRow(event: event) { updatedEvent in
                        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
                            events[index] = updatedEvent
                        }
                    }
                }
            }

            Button("Add New Event") {
                showAddEvent = true
            }
            .padding()
            .sheet(isPresented: $showAddEvent) {
                AddEventView(events: $events)
                    .environmentObject(authViewModel)
            }
        }
        .navigationTitle("Events")
    }
}
