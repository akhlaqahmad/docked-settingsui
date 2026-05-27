import SwiftUI
import AppCore
import DesignSystem
import DisplayKit

@MainActor
public struct SettingsWindow: View {
    @State private var listVM: DockListViewModel
    private let manager: DockManager
    private let displayObserver: DisplayObserver

    public init(manager: DockManager, displayObserver: DisplayObserver) {
        self.manager = manager
        self.displayObserver = displayObserver
        _listVM = State(initialValue: DockListViewModel(manager: manager))
    }

    public var body: some View {
        NavigationSplitView {
            DockListSidebar(viewModel: listVM, displayObserver: displayObserver)
                .navigationSplitViewColumnWidth(min: 220, ideal: 260)
        } detail: {
            if let dockID = listVM.selectedDockID {
                DockInspectorView(
                    viewModel: DockInspectorViewModel(dockID: dockID, manager: manager),
                    displayObserver: displayObserver
                )
            } else {
                DSEmptyState(
                    icon: "rectangle.stack.badge.plus",
                    title: "Create your first dock",
                    message: "Pin a customized dock to any display. Drag apps in to get started.",
                    actionTitle: "New Dock",
                    action: {
                        listVM.createDock(named: "New Dock", screenID: displayObserver.currentIdentifiers().first)
                    }
                )
            }
        }
        .frame(minWidth: 820, minHeight: 560)
    }
}
