import SwiftUI

struct AddEventView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var eventService: EventService

    @State private var title = ""
    @State private var location = ""
    @State private var description = ""
    @State private var date = Date()

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
                guard let organizer = authViewModel.currentUser else {
                    print("Error: No current user found.")
                    return
                }

                let newEvent = Event(
                    title: title,
                    location: location,
                    description: description,
                    date: date,
                    organizer: organizer,
                    attendees: [],
                    isAttending: false
                )
                
                eventService.addEvent(event: newEvent)
            }
            .padding()
        }
        .navigationTitle("Add New Event")
    }
}
