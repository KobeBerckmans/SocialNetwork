import SwiftUI
import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let sender: String
    let timestamp: Date
}
