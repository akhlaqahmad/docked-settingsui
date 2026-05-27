import SwiftUI
import AppCore
import DesignSystem
import DisplayKit

@MainActor
public struct OnboardingView: View {
    @State private var step: Int = 0
    private let displayObserver: DisplayObserver
    private let manager: DockManager
    private let onComplete: () -> Void

    public init(manager: DockManager, displayObserver: DisplayObserver, onComplete: @escaping () -> Void) {
        self.manager = manager
        self.displayObserver = displayObserver
        self.onComplete = onComplete
    }

    public var body: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            content
            HStack {
                if step > 0 {
                    Button("Back") { step -= 1 }
                        .keyboardShortcut(.cancelAction)
                }
                Spacer()
                Button(step == 3 ? "Open Dock" : "Continue") {
                    if step == 3 {
                        finish()
                    } else {
                        step += 1
                    }
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.bottom, DesignTokens.Spacing.l)
        }
        .frame(width: 560, height: 420)
    }

    @ViewBuilder
    private var content: some View {
        switch step {
        case 0:
            stepView(
                icon: "rectangle.stack.fill",
                title: "Pin a dock to every screen.",
                message: "Docked gives every display its own beautiful, customizable dock — pinned in place and styled how you want."
            )
        case 1:
            stepView(
                icon: "display.2",
                title: "Multi-monitor, built right.",
                message: "Each dock remembers which monitor it belongs to. Disconnect a screen — it hides. Reconnect — it comes back."
            )
        case 2:
            stepView(
                icon: "wand.and.stars",
                title: "Style every detail.",
                message: "Adjust size, opacity, blur, corner radius, and magnification. Pick a theme or roll your own."
            )
        default:
            stepView(
                icon: "checkmark.seal.fill",
                title: "All set.",
                message: "Your first dock is ready. Right-click any dock to customize it, or press ⌘, to open Settings."
            )
        }
    }

    private func stepView(icon: String, title: String, message: String) -> some View {
        VStack(spacing: DesignTokens.Spacing.l) {
            Spacer().frame(height: 24)
            Image(systemName: icon).font(.system(size: 56)).foregroundStyle(.tint)
            Text(title).font(.largeTitle.weight(.semibold)).multilineTextAlignment(.center)
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.xl)
            Spacer()
        }
    }

    private func finish() {
        if manager.library.docks.isEmpty {
            _ = try? manager.createDock(
                name: "My Dock",
                screenID: displayObserver.currentIdentifiers().first
            )
        }
        onComplete()
    }
}
