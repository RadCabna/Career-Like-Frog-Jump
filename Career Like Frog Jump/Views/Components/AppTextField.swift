import SwiftUI

struct AppTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))

                if text.isEmpty {
                    Text(placeholder)
                        .font(.body)
                        .foregroundStyle(AppColors.placeholder)
                        .padding(.horizontal, 16)
                        .allowsHitTesting(false)
                }

                TextField("", text: $text)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 16)
                    .textInputAutocapitalization(.sentences)
                    .autocorrectionDisabled(false)
            }
            .frame(height: 48)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(text.isEmpty ? placeholder : text)
    }
}

#Preview("Light") {
    AppTextFieldPreviewContainer()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    AppTextFieldPreviewContainer()
        .preferredColorScheme(.dark)
}

private struct AppTextFieldPreviewContainer: View {
    @State private var text = ""

    var body: some View {
        AppTextField(
            title: "Title",
            placeholder: "Enter text",
            text: $text
        )
        .padding()
    }
}
