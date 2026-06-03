import SwiftUI

struct AppTextField: View {
    let title: String
    let placeholder: String
    var placeholderFont: Font = .body
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppColors.secondaryLabel)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppColors.textFieldFill)

                if text.isEmpty {
                    Text(placeholder)
                        .font(placeholderFont)
                        .foregroundStyle(AppColors.placeholder)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                        .padding(.horizontal, 16)
                        .allowsHitTesting(false)
                }

                TextField("", text: $text)
                    .font(.body)
                    .foregroundStyle(AppColors.primaryLabel)
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

#Preview {
    AppTextFieldPreviewContainer()
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
