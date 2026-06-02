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
                    if store.tasks.isEmpty {
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
                        ForEach(Array(store.tasks.enumerated()), id: \.element.id) { index, task in
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
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .contentMargins(.top, 12, for: .scrollContent)
            .contentMargins(.bottom, store.hasGlobalGoal ? 88 : 24, for: .scrollContent)

            if store.hasGlobalGoal {
                RiverAddTaskButton(action: store.presentTaskCreation)
                .padding(.bottom, RiverElementLayoutConfig.frogPadBottomMargin)
                .safeAreaPadding(.bottom, 8)
            }
        }
        .tabScreenBackground(.river)
        .navigationTitle(AppTab.lilyPadMap.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .sheet(item: $sheetViewModel.activeSheet) { mode in
            NavigationStack {
                PlaceLilyPadFormContent(
                    title: mode.navigationTitle,
                    draft: $sheetViewModel.draft,
                    onTitleChange: sheetViewModel.updateTitleDraft,
                    onCancel: sheetViewModel.cancelSheet,
                    onSave: { sheetViewModel.saveDraft(for: mode, store: store) },
                    isSaveEnabled: sheetViewModel.draft.isValid
                )
            }
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

    private func driftOffset(for index: Int) -> CGFloat {
        let direction: CGFloat = index.isMultiple(of: 2) ? 1 : -1
        return direction * driftPhase * 0.35
    }
}

private extension LilyPadSheetMode {
    var navigationTitle: String {
        switch self {
        case .create: "Place a Lily Pad"
        case .edit: "Edit Lily Pad"
        }
    }
}

#Preview {
    NavigationStack {
        LilyPadMapView()
            .environmentObject(CareerPathStore())
    }
}
