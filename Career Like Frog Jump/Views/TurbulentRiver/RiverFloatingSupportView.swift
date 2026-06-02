import SwiftUI

struct RiverFloatingSupportView: View {
    let task: LilyPadTaskItem

    var body: some View {
        Image(task.category.riverAssetName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: RiverElementLayoutConfig.elementWidth(
                category: task.category,
                importance: task.importance
            ))
            .shadow(color: .black.opacity(0.28), radius: 6, y: 3)
            .accessibilityLabel(task.title)
    }
}

#Preview {
    RiverFloatingSupportView(
        task: LilyPadTaskItem(
            title: "Swift course",
            category: .hardSkills,
            deadline: Date(),
            importance: .medium
        )
    )
}
