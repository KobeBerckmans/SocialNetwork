import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let description: String
    let date: Date
    let organizer: String
    var attendees: [String]
    var isAttending: Bool

    mutating func toggleAttendance(for user: String) {
        if let index = attendees.firstIndex(of: user) {
            attendees.remove(at: index)
        } else {
            attendees.append(user)
        }
    }
}
