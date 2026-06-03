import SwiftUI

struct DayOffShieldView: View {
    @ObservedObject var viewModel: ThreatRadarViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer(minLength: 0)

                ZStack(alignment: .bottom) {
                    if let threat = viewModel.activeThreat {
                        DangerIconView(assetName: threat.dangerAssetName, size: screenHeight * 0.12)
                            .offset(y: -screenHeight * 0.02)
                    }

                    Image("lily")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenHeight * 0.14)
                        .opacity(0.35)

                    ShieldIconView(shield: .lifebuoyRest, size: screenHeight * 0.1)
                        .offset(y: -screenHeight * 0.04)

                    Image("frog1_5")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: RiverElementLayoutConfig.frogWidth)
                        .offset(y: -screenHeight * 0.055)
                }
                .frame(height: screenHeight * 0.2)

                VStack(spacing: 10) {
                    Text("Lifebuoy Rest")
                        .font(.title2.weight(.bold))

                    Text("Freeze progress for 24 hours. Your streak stays safe while the burnout bat flies away.")
                        .font(.subheadline)
                        .foregroundStyle(AppColors.secondaryLabel)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                }

                Spacer(minLength: 0)

                Button {
                    viewModel.activateDayOff()
                } label: {
                    Text("Activate Lifebuoy")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(AppColors.gold, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .padding(.top, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.lightGroupedBackground)
            .navigationTitle("Lifebuoy Shield")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        viewModel.dismissShieldFlow()
                    }
                }
            }
        }
    }
}
