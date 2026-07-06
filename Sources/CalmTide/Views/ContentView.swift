import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct ContentView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if appState.isSessionActive {
                BreathingSessionView()
            } else {
                DashboardView()
            }
        }
        .background(Color(red: 0.05, green: 0.09, blue: 0.12))
    }
}
