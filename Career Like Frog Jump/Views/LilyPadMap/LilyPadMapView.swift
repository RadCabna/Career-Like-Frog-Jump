import SwiftUI

struct LilyPadMapView: View {
    @EnvironmentObject private var store: CareerPathStore
    @StateObject private var sheetViewModel = LilyPadMapViewModel()
    @State private var driftPhase: CGFloat = 0

    private var listRowInsets: EdgeInsets {
        EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                if store.isBacklogCleanupActive {
                    BacklogCleanupBannerView()
                        .listRowInsets(listRowInsets)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }

                if store.shouldShowInlineGoalForm {
                    CreateGlobalGoalView()
                        .listRowInsets(listRowInsets)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                } else if let goalTitle = store.globalGoalTitle {
                    GoalTitleHeaderView(title: goalTitle)
                        .onTapGesture {
                            store.requestGoalEdit()
                        }
                        .listRowInsets(listRowInsets)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }

                if store.hasGlobalGoal {
                    if store.activeTasks.isEmpty {
                        Text("Tap + to add your first task.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.92))
                            .riverTextShadow()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .listRowInsets(listRowInsets)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(Array(store.activeTasks.enumerated()), id: \.element.id) { index, task in
                            FloatingLilyPadTaskView(
                                task: task,
                                driftOffset: driftOffset(for: index)
                            )
                            .listRowInsets(listRowInsets)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                sheetViewModel.presentEditSheet(for: task)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    store.deleteTask(task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                if !task.isCompleted {
                                    Button {
                                        store.delegateTask(task)
                                    } label: {
                                        Label("Delegate", systemImage: "person.crop.circle.badge.plus")
                                    }
                                    .tint(AppColors.gold)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .contentMargins(.top, 12, for: .scrollContent)
            .contentMargins(.bottom, showsAddTaskButton ? 88 : 24, for: .scrollContent)

            if showsAddTaskButton {
                RiverAddTaskButton(action: store.presentTaskCreation)
                .padding(.bottom, RiverElementLayoutConfig.frogPadBottomMargin)
                .safeAreaPadding(.bottom, 8)
            }
        }
        .tabScreenBackground(.river)
        .dismissKeyboardOnTapOutside()
        .navigationTitle(AppTab.lilyPadMap.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .fullScreenCover(item: $sheetViewModel.activeSheet) { mode in
            LilyPadTaskDetailFullScreenView(
                sheetViewModel: sheetViewModel,
                mode: mode,
                microSteps: microSteps(for: mode),
                completionComment: completionComment(for: mode)
            )
            .environmentObject(store)
        }
        .fullScreenCover(isPresented: $store.isPresentingTaskCreation) {
            PlaceLilyPadFullScreenView()
                .environmentObject(store)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                driftPhase = 6
            }
        }
    }

    private var showsAddTaskButton: Bool {
        store.hasGlobalGoal && store.canAddMoreTasks
    }

    private func driftOffset(for index: Int) -> CGFloat {
        let direction: CGFloat = index.isMultiple(of: 2) ? 1 : -1
        return direction * driftPhase * 0.35
    }

    private func microSteps(for mode: LilyPadSheetMode) -> [String] {
        guard case .edit(let task) = mode else { return [] }
        return store.tasks.first(where: { $0.id == task.id })?.microSteps ?? task.microSteps
    }

    private func completionComment(for mode: LilyPadSheetMode) -> String? {
        guard case .edit(let task) = mode else { return nil }
        guard let raw = store.tasks.first(where: { $0.id == task.id })?.completionComment else { return nil }
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}

#Preview {
    NavigationStack {
        LilyPadMapView()
            .environmentObject(CareerPathStore())
            .environmentObject(ThreatRadarViewModel())
    }
}
