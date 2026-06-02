import SwiftUI

struct PlaceLilyPadFullScreenView: View {
    @EnvironmentObject private var store: CareerPathStore

    var body: some View {
        ZStack {
            AppTabBackgroundView(kind: AppBackgroundStore.kind(for: .threatRadar))
                .ignoresSafeArea()

            NavigationStack {
                PlaceLilyPadFormContent(
                    title: "Place a Lily Pad",
                    draft: $store.taskCreationDraft,
                    onTitleChange: store.updateTaskCreationTitle,
                    onCancel: store.cancelTaskCreation,
                    onSave: store.saveTaskCreation,
                    isSaveEnabled: store.taskCreationDraft.isValid
                )
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
        }
    }
}

#Preview {
    PlaceLilyPadFullScreenView()
        .environmentObject(CareerPathStore())
}
