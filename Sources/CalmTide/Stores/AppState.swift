import Foundation
import Observation

@MainActor
@Observable
final class AppState {
    private enum Keys {
        static let settings = "calmtide.settings"
    }

    var settings: BreathingSettings {
        didSet {
            persistSettings()
            configureReminderTimer()
        }
    }

    var notificationStatus = "Reminders are off"
    var activeSession: SessionSnapshot?
    var isSessionActive = false

    private let notificationService = NotificationService()
    private var reminderTimer: Timer?
    private var sessionTimer: Timer?
    private var phaseIndex = 0
    private var cycle = 1

    init() {
        settings = Self.loadSettings()
        configureReminderTimer()
    }

    func requestNotificationPermission() {
        Task {
            let granted = await notificationService.requestPermission()
            notificationStatus = granted ? "Reminder permission granted" : "Reminder permission denied"
            configureReminderTimer()
        }
    }

    func startSession() {
        phaseIndex = 0
        cycle = 1
        isSessionActive = true
        beginCurrentPhase(isPaused: false)
    }

    func endSession() {
        sessionTimer?.invalidate()
        activeSession = nil
        isSessionActive = false
        notificationStatus = settings.remindersEnabled ? "Session ended. Reminders remain on." : "Session ended"
    }

    func togglePause() {
        guard var snapshot = activeSession else { return }
        snapshot.isPaused.toggle()
        activeSession = snapshot
    }

    func skipPhase() {
        advancePhase()
    }

    private func beginCurrentPhase(isPaused: Bool) {
        let phase = BreathingPhase.allCases[phaseIndex]
        activeSession = SessionSnapshot(
            phase: phase,
            secondsRemaining: settings.duration(for: phase),
            cycle: cycle,
            totalCycles: settings.cycles,
            isPaused: isPaused
        )
        startSessionTimerIfNeeded()
    }

    private func startSessionTimerIfNeeded() {
        sessionTimer?.invalidate()
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tickSession()
            }
        }
    }

    private func tickSession() {
        guard var snapshot = activeSession, isSessionActive else { return }
        guard !snapshot.isPaused else { return }

        if snapshot.secondsRemaining > 1 {
            snapshot.secondsRemaining -= 1
            activeSession = snapshot
        } else {
            advancePhase()
        }
    }

    private func advancePhase() {
        let phaseCount = BreathingPhase.allCases.count
        if phaseIndex < phaseCount - 1 {
            phaseIndex += 1
        } else if cycle < settings.cycles {
            phaseIndex = 0
            cycle += 1
        } else {
            endSession()
            return
        }

        beginCurrentPhase(isPaused: false)
    }

    private func configureReminderTimer() {
        reminderTimer?.invalidate()

        guard settings.remindersEnabled else {
            notificationStatus = "Reminders are off"
            return
        }

        notificationStatus = "Reminder every \(CalmFormatters.minutes(settings.reminderIntervalMinutes))"
        reminderTimer = Timer.scheduledTimer(withTimeInterval: settings.reminderIntervalMinutes * 60, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.sendReminder()
            }
        }
    }

    private func sendReminder() {
        notificationService.scheduleReminder(after: settings.reminderIntervalMinutes)
        notificationStatus = "Reminder sent. Next in \(CalmFormatters.minutes(settings.reminderIntervalMinutes))"
    }

    private func persistSettings() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        UserDefaults.standard.set(data, forKey: Keys.settings)
    }

    private static func loadSettings() -> BreathingSettings {
        guard
            let data = UserDefaults.standard.data(forKey: Keys.settings),
            let settings = try? JSONDecoder().decode(BreathingSettings.self, from: data)
        else {
            return BreathingSettings()
        }

        return settings
    }
}
