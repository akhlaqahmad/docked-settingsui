import SwiftUI
import AppCore
import DesignSystem
import DisplayKit

@MainActor
struct DockListSidebar: View {
    let viewModel: DockListViewModel
    let displayObserver: DisplayObserver

    var body: some View {
        @Bindable var viewModel = viewModel
        VStack(spacing: 0) {
            List(selection: $viewModel.selectedDockID) {
                Section("Docks") {
                    ForEach(viewModel.docks) { dock in
                        HStack {
                            Image(systemName: "rectangle.bottomthird.inset.filled")
                                .foregroundStyle(.tint)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(dock.name)
                                if let screenID = dock.screenID {
                                    Text(screenID.localizedName)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .tag(dock.id)
                    }
                }
            }
            .listStyle(.sidebar)

            Divider()
            HStack {
                Button(action: {
                    viewModel.createDock(
                        named: "Dock \(viewModel.docks.count + 1)",
                        screenID: displayObserver.currentIdentifiers().first
                    )
                }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.plain)
                .help("New Dock")

                Button(action: { viewModel.deleteSelected() }) {
                    Image(systemName: "minus")
                }
                .buttonStyle(.plain)
                .disabled(viewModel.selectedDockID == nil)
                .help("Delete Dock")

                Spacer()
            }
            .padding(.horizontal, DesignTokens.Spacing.m)
            .padding(.vertical, DesignTokens.Spacing.s)
        }
    }
}
