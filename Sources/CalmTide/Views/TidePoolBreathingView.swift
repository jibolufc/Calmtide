import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct TidePoolBreathingView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let phase: BreathingPhase
    let secondsRemaining: Int

    var body: some View {
        Group {
            if reduceMotion {
                TimelineView(.periodic(from: .now, by: 1)) { timeline in
                    tideCanvas(at: timeline.date)
                }
            } else {
                TimelineView(.animation) { timeline in
                    tideCanvas(at: timeline.date)
                }
            }
        }
    }

    private func tideCanvas(at date: Date) -> some View {
        Canvas { context, size in
                let time = date.timeIntervalSinceReferenceDate
                let rect = CGRect(origin: .zero, size: size)
                let base = Path(rect)

                context.fill(base, with: .linearGradient(
                    Gradient(colors: [
                        Color(red: 0.03, green: 0.11, blue: 0.15),
                        Color(red: 0.04, green: 0.24, blue: 0.28),
                        phase.color.opacity(0.58)
                    ]),
                    startPoint: .zero,
                    endPoint: CGPoint(x: size.width, y: size.height)
                ))

                let amplitude = reduceMotion ? 10.0 : 28.0
                let phaseShift = reduceMotion ? 0.0 : time
                let fillLevel = waterLevel(for: phase, height: size.height)

                var wave = Path()
                wave.move(to: CGPoint(x: 0, y: size.height))
                wave.addLine(to: CGPoint(x: 0, y: fillLevel))

                let step = max(4, size.width / 80)
                var x = 0.0
                while x <= size.width + step {
                    let primaryWave = CGFloat(sin((Double(x) / 55) + phaseShift * 1.5)) * amplitude
                    let secondaryWave = CGFloat(sin((Double(x) / 31) - phaseShift)) * amplitude * 0.42
                    let y = fillLevel + primaryWave + secondaryWave
                    wave.addLine(to: CGPoint(x: x, y: y))
                    x += step
                }

                wave.addLine(to: CGPoint(x: size.width, y: size.height))
                wave.closeSubpath()

                context.fill(wave, with: .linearGradient(
                    Gradient(colors: [
                        Color.cyan.opacity(0.76),
                        Color.teal.opacity(0.62),
                        Color.blue.opacity(0.7)
                    ]),
                    startPoint: CGPoint(x: size.width * 0.5, y: fillLevel),
                    endPoint: CGPoint(x: size.width * 0.5, y: size.height)
                ))

                drawRipples(in: &context, size: size, time: time)
        }
    }

    private func waterLevel(for phase: BreathingPhase, height: CGFloat) -> CGFloat {
        let position: CGFloat
        switch phase {
        case .inhale: position = 0.38
        case .hold: position = 0.31
        case .exhale: position = 0.56
        case .rest: position = 0.62
        }

        return height * position
    }

    private func drawRipples(in context: inout GraphicsContext, size: CGSize, time: TimeInterval) {
        let center = CGPoint(x: size.width * 0.5, y: size.height * 0.58)
        for index in 0..<5 {
            let rawProgress = reduceMotion ? Double(index) / 5 : (time * 0.18 + Double(index) * 0.2).truncatingRemainder(dividingBy: 1)
            let radius = CGFloat(80 + rawProgress * 280)
            let alpha = max(0, 0.22 - rawProgress * 0.2)
            let rect = CGRect(
                x: center.x - radius,
                y: center.y - radius * 0.34,
                width: radius * 2,
                height: radius * 0.68
            )
            context.stroke(
                Path(ellipseIn: rect),
                with: .color(.white.opacity(alpha)),
                lineWidth: 1.5
            )
        }
    }
}
