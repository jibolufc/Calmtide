import Foundation
import SwiftUI

enum BreathingPhase: String, CaseIterable, Identifiable, Codable {
    case inhale
    case hold
    case exhale
    case rest

    var id: String { rawValue }

    var title: String {
        switch self {
        case .inhale: "Inhale"
        case .hold: "Hold"
        case .exhale: "Exhale"
        case .rest: "Rest"
        }
    }

    var cue: String {
        switch self {
        case .inhale: "Let the tide rise"
        case .hold: "Float at the crest"
        case .exhale: "Let the tide fall"
        case .rest: "Settle into still water"
        }
    }

    var color: Color {
        switch self {
        case .inhale: Color.teal
        case .hold: Color.indigo
        case .exhale: Color.blue
        case .rest: Color.mint
        }
    }
}

struct BreathingSettings: Codable, Equatable {
    var cycles: Int = 4
    var inhaleDuration: Int = 4
    var holdDuration: Int = 4
    var exhaleDuration: Int = 6
    var restDuration: Int = 2
    var remindersEnabled: Bool = false
    var reminderIntervalMinutes: Double = 30

    func duration(for phase: BreathingPhase) -> Int {
        switch phase {
        case .inhale: inhaleDuration
        case .hold: holdDuration
        case .exhale: exhaleDuration
        case .rest: restDuration
        }
    }
}

struct SessionSnapshot: Equatable {
    var phase: BreathingPhase
    var secondsRemaining: Int
    var cycle: Int
    var totalCycles: Int
    var isPaused: Bool

    var progressLabel: String {
        "Cycle \(cycle) of \(totalCycles)"
    }
}
