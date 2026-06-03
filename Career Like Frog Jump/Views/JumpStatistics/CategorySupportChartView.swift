import SwiftUI

struct CategorySupportChartView: View {
    let slices: [CategoryEffortSlice]

    private var chartDiameter: CGFloat {
        screenWidth * 0.46
    }

    private var totalCompleted: Int {
        slices.reduce(0) { $0 + $1.completedCount }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Support pillars")
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .riverTextShadow()

            Text("Effort by category")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.75))
                .riverTextShadow()

            if totalCompleted == 0 {
                emptyState
            } else {
                VStack(spacing: 18) {
                    donutChart
                        .frame(width: chartDiameter, height: chartDiameter)
                        .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(slices) { slice in
                            legendRow(for: slice)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.frostedPanel)
        )
    }

    private var emptyState: some View {
        Text("Finish tasks to see how your effort spreads across pillars.")
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.85))
            .riverTextShadow()
            .frame(maxWidth: .infinity, minHeight: chartDiameter * 0.6, alignment: .leading)
    }

    private var donutChart: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let outerRadius = min(size.width, size.height) * 0.46
            let innerRadius = outerRadius * 0.52
            var startAngle = Angle.degrees(-90)

            for slice in slices where slice.completedCount > 0 {
                let sweep = Angle.degrees(360 * slice.share)
                var path = Path()
                path.addArc(
                    center: center,
                    radius: outerRadius,
                    startAngle: startAngle,
                    endAngle: startAngle + sweep,
                    clockwise: false
                )
                path.addArc(
                    center: center,
                    radius: innerRadius,
                    startAngle: startAngle + sweep,
                    endAngle: startAngle,
                    clockwise: true
                )
                path.closeSubpath()
                context.fill(path, with: .color(color(for: slice.category)))
                startAngle += sweep
            }

            let hole = Path(ellipseIn: CGRect(
                x: center.x - innerRadius * 0.55,
                y: center.y - innerRadius * 0.55,
                width: innerRadius * 1.1,
                height: innerRadius * 1.1
            ))
            context.fill(hole, with: .color(.black.opacity(0.35)))

            let totalLabel = Text("\(totalCompleted)")
                .font(.system(size: 28, weight: .black, design: .monospaced))
                .foregroundColor(.white)
            context.draw(totalLabel, at: center, anchor: .center)

            let subtitle = Text("tasks")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.75))
            context.draw(subtitle, at: CGPoint(x: center.x, y: center.y + 17), anchor: .center)
        }
    }

    private func legendRow(for slice: CategoryEffortSlice) -> some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(color(for: slice.category))
                .frame(width: 12, height: 12)

            Text(slice.category.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppColors.primaryLabel)

            Spacer(minLength: 0)

            Text("\(slice.completedCount) · \(percentText(slice.share))")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppColors.secondaryLabel)
        }
    }

    private func percentText(_ share: Double) -> String {
        guard share > 0 else { return "0%" }
        return "\(Int((share * 100).rounded()))%"
    }

    private func color(for category: LilyPadCategory) -> Color {
        switch category {
        case .hardSkills: AppColors.neonGreen
        case .networking: AppColors.gold
        case .projects: AppColors.chartProjectsBlue
        }
    }
}

#Preview {
    ZStack {
        Color.black
        CategorySupportChartView(
            slices: [
                CategoryEffortSlice(category: .hardSkills, completedCount: 4, totalCompleted: 9),
                CategoryEffortSlice(category: .networking, completedCount: 2, totalCompleted: 9),
                CategoryEffortSlice(category: .projects, completedCount: 3, totalCompleted: 9)
            ]
        )
        .padding()
    }
}
