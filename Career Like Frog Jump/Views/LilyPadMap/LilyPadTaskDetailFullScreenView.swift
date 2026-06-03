import SwiftUI

struct LilyPadTaskDetailFullScreenView: View {
    @EnvironmentObject private var store: CareerPathStore
    @ObservedObject var sheetViewModel: LilyPadMapViewModel
    let mode: LilyPadSheetMode
    let microSteps: [String]
    let completionComment: String?

    var body: some View {
        NavigationStack {
            PlaceLilyPadFormContent(
                title: mode.navigationTitle,
                draft: $sheetViewModel.draft,
                microSteps: microSteps,
                completionComment: completionComment,
                onTitleChange: sheetViewModel.updateTitleDraft,
                onCancel: sheetViewModel.cancelSheet,
                onSave: { sheetViewModel.saveDraft(for: mode, store: store) },
                isSaveEnabled: sheetViewModel.draft.isValid
            )
        }
        .background(Color.white.ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .dismissKeyboardOnTapOutside()
    }
}
