import SwiftUI

struct PlaceLilyPadFormView: View {
    let mode: LilyPadSheetMode
    @ObservedObject var viewModel: LilyPadMapViewModel
    @ObservedObject var store: CareerPathStore

    var body: some View {
        NavigationStack {
            PlaceLilyPadFormContent(
                title: mode.navigationTitle,
                draft: $viewModel.draft,
                onTitleChange: viewModel.updateTitleDraft,
                onCancel: viewModel.cancelSheet,
                onSave: { viewModel.saveDraft(for: mode, store: store) },
                isSaveEnabled: viewModel.draft.isValid
            )
        }
    }
}
