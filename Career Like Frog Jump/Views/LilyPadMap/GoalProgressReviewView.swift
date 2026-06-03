import SwiftUI

struct GoalProgressReviewView: View {
    let goalTitle: String
    let tasks: [LilyPadTaskItem]
    let primaryButtonTitle: String
    let onPrimary: () -> Void

    @State private var driftPhase: CGFloat = 0
    @State private var selectedTask: LilyPadTaskItem?

    private var listRowInsets: EdgeInsets {
        EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                List {
                    GoalTitleHeaderView(title: goalTitle)
                        .listRowInsets(listRowInsets)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)

                    ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                        FloatingLilyPadTaskView(
                            task: task,
                            driftOffset: driftOffset(for: index)
                        )
                        .listRowInsets(listRowInsets)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            selectedTask = task
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .contentMargins(.top, 12, for: .scrollContent)
                .contentMargins(.bottom, 96, for: .scrollContent)

                Button(action: onPrimary) {
                    Text(primaryButtonTitle)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(AppColors.neonGreen, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, RiverElementLayoutConfig.frogPadBottomMargin)
                .safeAreaPadding(.bottom, 8)
            }
            .tabScreenBackground(.river)
            .navigationTitle("Your Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .fullScreenCover(isPresented: Binding(
                get: { selectedTask != nil },
                set: { if !$0 { selectedTask = nil } }
            )) {
                if let task = selectedTask {
                    ReadOnlyTaskDetailView(task: task) {
                        selectedTask = nil
                    }
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                    driftPhase = 6
                }
            }
        }
    }

    private func driftOffset(for index: Int) -> CGFloat {
        let direction: CGFloat = index.isMultiple(of: 2) ? 1 : -1
        return direction * driftPhase * 0.35
    }
}
