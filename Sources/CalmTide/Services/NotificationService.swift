import Foundation
import UserNotifications

@MainActor
final class NotificationService {
    private let center = UNUserNotificationCenter.current()

    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func scheduleReminder(after minutes: Double) {
        let content = UNMutableNotificationContent()
        content.title = "CalmTide"
        content.body = "Take a quiet minute for a breathing session."
        content.sound = .default

        let seconds = max(60, Int(minutes * 60))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        let request = UNNotificationRequest(
            identifier: "calmtide.reminder.\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }
}
