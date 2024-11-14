import SwiftUI

struct EventRow: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var event: Event
    var onAttendanceChanged: (Event) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.headline)
            Text("Location: \(event.location)")
                .font(.subheadline)
            Text("Organizer: \(event.organizer)")
                .font(.footnote)
                .foregroundColor(.gray)
            Text(event.description)
                .font(.body)
            Text("Date: \(event.date, formatter: dateFormatter)")
                .font(.footnote)

            if !event.attendees.isEmpty {
                Text("Attendees: \(event.attendees.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }

            Button(event.isAttending ? "Mark as Absent" : "Mark as Attending") {
                var updatedEvent = event
                updatedEvent.toggleAttendance(for: authViewModel.currentUser ?? "Unknown")
                updatedEvent.isAttending.toggle()
                onAttendanceChanged(updatedEvent)
            }
            .padding(.top, 5)
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 5)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
