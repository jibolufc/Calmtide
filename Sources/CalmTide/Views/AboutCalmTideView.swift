import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct AboutCalmTideView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header

                aboutSection(
                    title: "What CalmTide Does",
                    systemImage: "water.waves",
                    text: "CalmTide guides you through simple breathing cycles with a tide animation, adjustable phase lengths, and gentle reminders. It is built for quick pauses, wind-down moments, and steady daily practice."
                )

                aboutSection(
                    title: "How To Use It",
                    systemImage: "lungs.fill",
                    text: "Choose the number of cycles, set the inhale, hold, exhale, and rest durations, then start a session. Follow the phase name, countdown, and water movement. Pause, skip, or end whenever you need."
                )

                aboutSection(
                    title: "Reminders",
                    systemImage: "bell.badge.fill",
                    text: "Reminders are local notifications from your device. They are optional, and you can change or turn them off from the dashboard at any time."
                )

                aboutSection(
                    title: "Privacy",
                    systemImage: "lock.shield.fill",
                    text: "CalmTide stores your settings on this device with UserDefaults. It does not require an account, and this version does not send breathing settings or session activity to a server."
                )

                aboutSection(
                    title: "A Gentle Note",
                    systemImage: "heart.text.square.fill",
                    text: "CalmTide is a wellness tool, not medical care. If breathing exercises feel uncomfortable, stop the session and return to a natural breathing rhythm."
                )

                versionFooter
            }
            .padding(24)
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.09, blue: 0.12),
                    Color(red: 0.06, green: 0.18, blue: 0.2),
                    Color(red: 0.12, green: 0.14, blue: 0.2)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("About CalmTide")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: closeButtonPlacement) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image("AppIconPreview")
                .resizable()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .accessibilityHidden(true)

            Text("CalmTide")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("A quiet breathing companion for resetting your pace.")
                .font(.title3)
                .foregroundStyle(.white.opacity(0.74))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
    }

    private func aboutSection(title: String, systemImage: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(.white)
            Text(text)
                .font(.body)
                .foregroundStyle(.white.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.white.opacity(0.12))
        }
    }

    private var versionFooter: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Version \(Bundle.main.appVersion)")
                .font(.footnote.weight(.semibold))
            Text("Icon direction: moonlit tide, calm water, and a soft breath circle.")
                .font(.footnote)
        }
        .foregroundStyle(.white.opacity(0.58))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }

    private var closeButtonPlacement: ToolbarItemPlacement {
        #if os(macOS)
        .automatic
        #else
        .topBarTrailing
        #endif
    }
}

private extension Bundle {
    var appVersion: String {
        let version = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = object(forInfoDictionaryKey: "CFBundleVersion") as? String

        switch (version, build) {
        case let (.some(version), .some(build)):
            return "\(version) (\(build))"
        case let (.some(version), .none):
            return version
        default:
            return "1.0"
        }
    }
}
