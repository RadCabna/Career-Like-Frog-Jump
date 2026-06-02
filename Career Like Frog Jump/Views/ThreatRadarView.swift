import SwiftUI

struct ThreatRadarView: View {
    @StateObject private var viewModel = ThreatRadarViewModel()

    var body: some View {
        List {
            Section {
                ForEach(viewModel.threats) { threat in
                    ThreatRow(threat: threat)
                }
            } header: {
                Text("Active Threats")
            } footer: {
                Text("Use an Awareness Shield to turn stress into reflection instead of a loss.")
            }

            Section {
                HStack {
                    Label("Awareness Shields", systemImage: "shield.lefthalf.filled")
                    Spacer()
                    Text("\(viewModel.shieldsAvailable)")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppColors.neonGreen)
                }

                Button {
                    viewModel.activateAwarenessShield()
                } label: {
                    Text("Activate Awareness Shield")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
                .foregroundStyle(AppColors.neonGreen)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .tabScreenBackground(AppBackgroundStore.kind(for: .threatRadar))
        .navigationTitle(AppTab.threatRadar.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        ThreatRadarView()
    }
}
