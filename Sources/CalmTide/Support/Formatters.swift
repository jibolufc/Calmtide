import Foundation

enum CalmFormatters {
    static func seconds(_ value: Int) -> String {
        let minutes = value / 60
        let seconds = value % 60

        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        }

        return "\(seconds)"
    }

    static func minutes(_ value: Double) -> String {
        "\(Int(value.rounded())) min"
    }
}
