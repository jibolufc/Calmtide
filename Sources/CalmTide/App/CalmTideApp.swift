import SwiftUI

#if os(macOS)
import AppKit
#endif

@available(iOS 17.0, macOS 14.0, *)
@main
struct CalmTideApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
        #if os(macOS)
        .commands {
            CommandGroup(replacing: .appTermination) {
                Button("Quit CalmTide") {
                    NSApp.terminate(nil)
                }
                .keyboardShortcut("q")
            }
        }
        #endif
    }
}
