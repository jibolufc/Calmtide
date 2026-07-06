import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct DashboardView: View {
    @Environment(AppState.self) private var appState
    @State private var destination: DashboardDestination?

    var body: some View {
        @Bindable var appState = appState

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    sessionControls(settings: $appState.settings)
                    phaseControls(settings: $appState.settings)
                    reminderControls(settings: $appState.settings)
                    startButton
                }
                .padding(24)
            }
            .navigationTitle("CalmTide")
            #if os(iOS)
            .toolbarTitleDisplayMode(.inline)
            #endif
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.04, green: 0.09, blue: 0.12),
                        Color(red: 0.05, green: 0.16, blue: 0.18),
                        Color(red: 0.13, green: 0.17, blue: 0.24)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .task {
                appState.requestNotificationPermission()
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        destination = .about
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .accessibilityLabel("About CalmTide")
                }
            }
            .sheet(item: $destination) { destination in
                switch destination {
                case .about:
                    NavigationStack {
                        AboutCalmTideView()
                    }
                    #if os(macOS)
                    .frame(minWidth: 460, minHeight: 640)
                    #endif
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Guided breathing")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            Text("Shape a steady tide: breathe in, hold, breathe out, and rest.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.72))
        }
        .padding(.top, 8)
    }

    private func sessionControls(settings: Binding<BreathingSettings>) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Session")
                .font(.headline)
            Stepper("Cycles: \(settings.wrappedValue.cycles)", value: settings.cycles, in: 1...12)
        }
        .calmPanel()
    }

    private func phaseControls(settings: Binding<BreathingSettings>) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Phase durations")
                .font(.headline)
            durationStepper("Inhale", value: settings.inhaleDuration)
            durationStepper("Hold", value: settings.holdDuration)
            durationStepper("Exhale", value: settings.exhaleDuration)
            durationStepper("Rest", value: settings.restDuration)
        }
        .calmPanel()
    }

    private func reminderControls(settings: Binding<BreathingSettings>) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Reminders", isOn: settings.remindersEnabled)
            VStack(alignment: .leading, spacing: 8) {
                Text("Interval: \(CalmFormatters.minutes(settings.wrappedValue.reminderIntervalMinutes))")
                Slider(value: settings.reminderIntervalMinutes, in: 5...120, step: 5)
            }
            Text(appState.notificationStatus)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .calmPanel()
    }

    private var startButton: some View {
        Button {
            appState.startSession()
        } label: {
            Label("Start Breathing", systemImage: "water.waves")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .tint(.teal)
        .controlSize(.large)
    }

    private func durationStepper(_ title: String, value: Binding<Int>) -> some View {
        Stepper("\(title): \(value.wrappedValue)s", value: value, in: 1...20)
    }
}

private enum DashboardDestination: Identifiable {
    case about

    var id: String {
        switch self {
        case .about: "about"
        }
    }
}

private extension View {
    func calmPanel() -> some View {
        self
            .foregroundStyle(.white)
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.white.opacity(0.12))
            )
    }
}
