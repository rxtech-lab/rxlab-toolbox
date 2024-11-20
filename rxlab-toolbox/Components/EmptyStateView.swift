import SwiftUI

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let message: String

    init(
        iconName: String,
        title: String,
        message: String
    ) {
        self.iconName = iconName
        self.title = title
        self.message = message
    }

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: iconName)
                .font(.system(size: 70))
                .foregroundColor(.gray)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
