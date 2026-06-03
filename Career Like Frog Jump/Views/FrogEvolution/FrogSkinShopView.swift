import SwiftUI

struct FrogSkinShopView: View {
    @EnvironmentObject private var store: CareerPathStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Skin Shop")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .riverTextShadow()

                Spacer(minLength: 0)

                FlyCoinBadge(amount: store.flyCoins)
            }

            Text("Spend flies on cosmetic river looks.")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.85))
                .riverTextShadow()

            ForEach(FrogSkinCatalog.all) { skin in
                FrogSkinShopRow(
                    skin: skin,
                    isOwned: store.ownsSkin(skin.id),
                    isEquipped: store.equippedSkinID == skin.id,
                    canPurchase: store.canPurchaseSkin(skin),
                    onPurchase: { store.purchaseSkin(skin.id) },
                    onEquip: { store.equipSkin(skin.id) }
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.frostedPanel)
        )
    }
}

private struct FrogSkinShopRow: View {
    let skin: FrogSkinDefinition
    let isOwned: Bool
    let isEquipped: Bool
    let canPurchase: Bool
    let onPurchase: () -> Void
    let onEquip: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(skin.shopPreviewFrame)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screenHeight * 0.07, height: screenHeight * 0.07)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.black.opacity(0.15))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(skin.title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppColors.primaryLabel)

                Text(skin.subtitle)
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryLabel)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            actionButton
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.frostedPanel)
                .overlay {
                    if isEquipped {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(AppColors.neonGreen, lineWidth: 2)
                    }
                }
        )
    }

    @ViewBuilder
    private var actionButton: some View {
        if isEquipped {
            Text("Equipped")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppColors.neonGreen)
        } else if isOwned {
            Button("Equip", action: onEquip)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(AppColors.neonGreen, in: Capsule())
                .buttonStyle(.plain)
        } else if skin.isDefault {
            Text("Free")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppColors.secondaryLabel)
        } else {
            Button {
                onPurchase()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "ladybug.fill")
                    Text("\(skin.price)")
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(canPurchase ? .white : .secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    canPurchase ? AppColors.gold : Color.gray.opacity(0.35),
                    in: Capsule()
                )
            }
            .buttonStyle(.plain)
            .disabled(!canPurchase)
        }
    }
}
