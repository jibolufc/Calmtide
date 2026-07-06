import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct BreathingSessionView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            if let snapshot = appState.activeSession {
                TidePoolBreathingView(phase: snapshot.phase, secondsRemaining: snapshot.secondsRemaining)
                    .ignoresSafeArea()
                    .accessibilityHidden(true)

                VStack(spacing: 22) {
                    Spacer()

                    VStack(spacing: 10) {
                        Text(snapshot.progressLabel)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.72))
                        Text(snapshot.phase.title)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text(snapshot.phase.cue)
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.78))
                        Text(CalmFormatters.seconds(snapshot.secondsRemaining))
                            .font(.system(size: 84, weight: .semibold, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.white)
                            .contentTransition(reduceMotion ? .identity : .numericText())
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                    Spacer()

                    HStack(spacing: 12) {
                        Button {
                            appState.togglePause()
                        } label: {
                            Label(snapshot.isPaused ? "Resume" : "Pause", systemImage: snapshot.isPaused ? "play.fill" : "pause.fill")
                                .frame(maxWidth: .infinity)
                        }

                        Button {
                            appState.skipPhase()
                        } label: {
                            Label("Skip", systemImage: "forward.fill")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white.opacity(0.18))

                    Button(role: .destructive) {
                        appState.endSession()
                    } label: {
                        Label("End Session", systemImage: "xmark.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .padding(.bottom, 28)
                }
                .padding(24)
            }
        }
        .background(Color(red: 0.02, green: 0.08, blue: 0.1))
    }
}
