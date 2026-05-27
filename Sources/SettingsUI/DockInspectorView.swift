import SwiftUI
import AppCore
import DesignSystem
import DisplayKit

@MainActor
struct DockInspectorView: View {
    let viewModel: DockInspectorViewModel
    let displayObserver: DisplayObserver

    var body: some View {
        @Bindable var viewModel = viewModel
        if let dock = viewModel.dock {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
                    header(dock: dock)
                    appearanceSection(dock: dock)
                    behaviorSection(dock: dock)
                    screenSection(dock: dock)
                    itemsSection(dock: dock)
                }
                .padding(DesignTokens.Spacing.xl)
            }
        } else {
            ProgressView()
        }
    }

    private func header(dock: Dock) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text(dock.name).font(.largeTitle.weight(.semibold))
            Text("Last modified \(dock.updatedAt.formatted(.relative(presentation: .named)))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func appearanceSection(dock: Dock) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.m) {
            DSSectionHeader("Appearance")

            HStack {
                Text("Icon size").frame(width: 110, alignment: .leading)
                Slider(
                    value: Binding(
                        get: { dock.appearance.iconSize },
                        set: { viewModel.setIconSize($0) }
                    ),
                    in: 24...128
                )
                Text("\(Int(dock.appearance.iconSize)) pt").monospacedDigit().frame(width: 60)
            }

            HStack {
                Text("Spacing").frame(width: 110, alignment: .leading)
                Slider(
                    value: Binding(
                        get: { dock.appearance.spacing },
                        set: { viewModel.setSpacing($0) }
                    ),
                    in: 0...32
                )
                Text("\(Int(dock.appearance.spacing)) pt").monospacedDigit().frame(width: 60)
            }

            HStack {
                Text("Opacity").frame(width: 110, alignment: .leading)
                Slider(
                    value: Binding(
                        get: { dock.appearance.opacity },
                        set: { viewModel.setOpacity($0) }
                    ),
                    in: 0.4...1.0
                )
                Text("\(Int(dock.appearance.opacity * 100))%").monospacedDigit().frame(width: 60)
            }

            HStack {
                Text("Corner radius").frame(width: 110, alignment: .leading)
                Slider(
                    value: Binding(
                        get: { dock.appearance.cornerRadius },
                        set: { viewModel.setCornerRadius($0) }
                    ),
                    in: 0...32
                )
                Text("\(Int(dock.appearance.cornerRadius)) pt").monospacedDigit().frame(width: 60)
            }

            Picker("Theme", selection: Binding(
                get: { dock.appearance.theme },
                set: { viewModel.setTheme($0) }
            )) {
                ForEach(ThemeID.allCases, id: \.self) { theme in
                    Text(theme.rawValue.capitalized).tag(theme)
                }
            }

            Toggle("Magnification on hover", isOn: Binding(
                get: { dock.appearance.magnification.enabled },
                set: { viewModel.toggleMagnification($0) }
            ))
        }
    }

    private func behaviorSection(dock: Dock) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.m) {
            DSSectionHeader("Behavior")
            Picker("Auto-hide", selection: Binding(
                get: { dock.behavior.autoHide },
                set: { viewModel.setAutoHide($0) }
            )) {
                ForEach(DockBehavior.AutoHide.allCases, id: \.self) { mode in
                    Text(mode.rawValue.capitalized).tag(mode)
                }
            }
        }
    }

    private func screenSection(dock: Dock) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.m) {
            DSSectionHeader("Display")
            Text(dock.screenID?.localizedName ?? "Following main display")
                .foregroundStyle(.secondary)
        }
    }

    private func itemsSection(dock: Dock) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.m) {
            DSSectionHeader("Items", helper: "Drag apps from Finder onto the dock to add them.")
            if dock.items.isEmpty {
                DSEmptyState(
                    icon: "tray",
                    title: "No items yet",
                    message: "Drag apps, folders, or files onto the floating dock to populate it."
                )
            } else {
                ForEach(dock.items) { item in
                    HStack {
                        Image(systemName: "circle.fill").font(.caption2).foregroundStyle(.tertiary)
                        Text(item.displayName)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}
