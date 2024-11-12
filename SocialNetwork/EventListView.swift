import SwiftUI

struct EventListView: View {
    @StateObject var eventService = EventService()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var filterLocation: String = ""
    @State private var showAddEvent = false
    @State private var showSettings = false
    @State private var navigateToLogin = false

    var filteredEvents: [Event] {
        if filterLocation.isEmpty {
            return eventService.events
        } else {
            return eventService.events.filter { $0.location.lowercased().contains(filterLocation.lowercased()) }
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
                        EventRow(event: event, onEventUpdated: { updatedEvent in
                            eventService.updateEvent(event: updatedEvent)
                        })
                        .environmentObject(authViewModel)
                    }
                }

                Button("Add New Event") {
                    showAddEvent = true
                }
                .padding()
                .sheet(isPresented: $showAddEvent) {
                    AddEventView(eventService: eventService)
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(authViewModel: _authViewModel, navigateToLogin: $navigateToLogin)
            }

            // Zorg voor de navigatie naar de LoginView als de navigateToLogin true is
            NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                EmptyView()
            }
            .hidden()
        }
    }
}

