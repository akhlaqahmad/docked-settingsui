import SwiftUI
import AppCore
import DesignSystem

@MainActor
public struct LicenseSettingsView: View {
    @State private var licenseKey: String = ""
    @State private var isActivating: Bool = false
    @State private var statusMessage: String?
    private let licenseService: LicenseServiceProtocol

    public init(licenseService: LicenseServiceProtocol) {
        self.licenseService = licenseService
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.l) {
            DSSectionHeader("License", helper: "Activate your Docked Pro key.")

            let license = licenseService.currentLicense()

            if license.isPro {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.s) {
                    Label("Docked Pro is active", systemImage: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                    if let email = license.email {
                        Text("Activated under \(email)").font(.caption).foregroundStyle(.secondary)
                    }
                    Button("Deactivate this device") {
                        Task { try? await licenseService.deactivate() }
                    }
                }
            } else {
                TextField("XXXX-XXXX-XXXX-XXXX", text: $licenseKey)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
                    .disableAutocorrection(true)

                HStack {
                    Button("Activate") {
                        Task { await activate() }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isActivating || licenseKey.count < 8)

                    if isActivating { ProgressView().scaleEffect(0.7) }
                }

                if let statusMessage {
                    Text(statusMessage).font(.caption).foregroundStyle(.red)
                }

                Link("Buy a license →", destination: URL(string: "https://docked.my/buy")!)
                    .font(.caption)
            }
        }
        .padding(DesignTokens.Spacing.xl)
        .frame(maxWidth: 520, alignment: .leading)
    }

    private func activate() async {
        isActivating = true
        defer { isActivating = false }
        do {
            _ = try await licenseService.activate(key: licenseKey)
            statusMessage = nil
            licenseKey = ""
        } catch {
            statusMessage = error.localizedDescription
        }
    }
}
