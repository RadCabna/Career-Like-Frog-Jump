import SwiftUI

struct PlaceLilyPadFullScreenView: View {
    @EnvironmentObject private var store: CareerPathStore

    var body: some View {
        NavigationStack {
            PlaceLilyPadFormContent(
                title: "Place a Lily Pad",
                draft: $store.taskCreationDraft,
                onTitleChange: store.updateTaskCreationTitle,
                onCancel: store.cancelTaskCreation,
                onSave: store.saveTaskCreation,
                isSaveEnabled: store.taskCreationDraft.isValid
            )
        }
        .background(Color.white.ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .dismissKeyboardOnTapOutside()
    }
}

#Preview {
    PlaceLilyPadFullScreenView()
        .environmentObject(CareerPathStore())
}
