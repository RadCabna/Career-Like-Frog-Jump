import SwiftUI

struct WeeklyJumpPaceChartView: View {
    let weeks: [WeeklyJumpDataPoint]

    private let pixel: CGFloat = 4
    private let chartHeight: CGFloat = 120

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Jumps per week")
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .riverTextShadow()

            if weeks.isEmpty {
                emptyState
            } else {
                Canvas { context, size in
                    drawChart(in: &context, size: size)
                }
                .frame(height: chartHeight + 28)

                HStack(spacing: 16) {
                    legendItem(color: AppColors.neonGreen, title: "Progress")
                    legendItem(color: AppColors.chartIdleRed, title: "Idle")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(chartCardBackground)
    }

    private var emptyState: some View {
        Text("Complete jumps on the river to build your pace chart.")
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.85))
            .riverTextShadow()
            .frame(maxWidth: .infinity, minHeight: chartHeight, alignment: .leading)
    }

    private var chartCardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(AppColors.frostedPanel)
    }

    private func legendItem(color: Color, title: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(color)
                .frame(width: 12, height: 12)
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(AppColors.secondaryLabel)
        }
    }

    private func drawChart(in context: inout GraphicsContext, size: CGSize) {
        let labelHeight: CGFloat = 22
        let plotHeight = chartHeight
        let plotWidth = size.width
        let maxCount = max(weeks.map(\.jumpCount).max() ?? 0, 1)
        let pointCount = weeks.count
        guard pointCount > 0 else { return }

        let horizontalStep = plotWidth / CGFloat(max(pointCount - 1, 1))

        func snap(_ value: CGFloat) -> CGFloat {
            floor(value / pixel) * pixel
        }

        func point(at index: Int) -> CGPoint {
            let week = weeks[index]
            let x = snap(CGFloat(index) * horizontalStep)
            let normalized = CGFloat(week.jumpCount) / CGFloat(maxCount)
            let y = snap(plotHeight - normalized * (plotHeight - pixel * 2))
            return CGPoint(x: x, y: y)
        }

        for row in 0...4 {
            let y = snap(CGFloat(row) * (plotHeight / 4))
            var grid = Path()
            grid.move(to: CGPoint(x: 0, y: y))
            grid.addLine(to: CGPoint(x: plotWidth, y: y))
            context.stroke(
                grid,
                with: .color(.white.opacity(0.08)),
                style: StrokeStyle(lineWidth: pixel, lineCap: .square)
            )
        }

        if pointCount > 1 {
            for index in 1..<pointCount {
                let from = point(at: index - 1)
                let to = point(at: index)
                let isIdleSegment = weeks[index].isIdleWeek || weeks[index - 1].isIdleWeek
                drawPixelSegment(
                    in: &context,
                    from: from,
                    to: to,
                    color: isIdleSegment ? AppColors.chartIdleRed : AppColors.neonGreen
                )
            }
        }

        for index in weeks.indices {
            let center = point(at: index)
            let markerColor = weeks[index].isIdleWeek ? AppColors.chartIdleRed : AppColors.neonGreen
            let marker = CGRect(
                x: center.x - pixel,
                y: center.y - pixel,
                width: pixel * 2,
                height: pixel * 2
            )
            context.fill(Path(marker), with: .color(markerColor))
        }

        for index in weeks.indices {
            let week = weeks[index]
            let x = snap(CGFloat(index) * horizontalStep)
            let label = Text(week.shortLabel)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.7))
            context.draw(
                label,
                at: CGPoint(x: x, y: plotHeight + labelHeight - 6),
                anchor: .top
            )
        }
    }

    private func drawPixelSegment(
        in context: inout GraphicsContext,
        from: CGPoint,
        to: CGPoint,
        color: Color
    ) {
        var path = Path()
        path.move(to: from)
        path.addLine(to: CGPoint(x: to.x, y: from.y))
        path.addLine(to: to)
        context.stroke(
            path,
            with: .color(color),
            style: StrokeStyle(lineWidth: pixel, lineCap: .square, lineJoin: .miter)
        )
    }
}

#Preview {
    ZStack {
        Color.black
        WeeklyJumpPaceChartView(
            weeks: [
                WeeklyJumpDataPoint(id: 0, weekStart: Date(), shortLabel: "Apr 7", jumpCount: 2),
                WeeklyJumpDataPoint(id: 1, weekStart: Date(), shortLabel: "Apr 14", jumpCount: 0),
                WeeklyJumpDataPoint(id: 2, weekStart: Date(), shortLabel: "Apr 21", jumpCount: 5),
                WeeklyJumpDataPoint(id: 3, weekStart: Date(), shortLabel: "Apr 28", jumpCount: 1)
            ]
        )
        .padding()
    }
}
