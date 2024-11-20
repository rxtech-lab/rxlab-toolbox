import SwiftUI

struct SplashScreen: View {
    @Environment(\.dismiss) var dismiss
    @Binding var document: RxToolboxDocument

    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                // Gradient Bar
                Image(systemName: "gear.badge")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.blue)
                    .frame(height: 100)
                    .padding(.horizontal)

                // Title
                VStack(spacing: 8) {
                    Text("Welcome to")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(AppStrings.appName.rawValue)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }

                // Features List
                VStack(alignment: .leading, spacing: 25) {
                    FeatureRow(
                        icon: "server.rack",
                        title: "Tools in one place",
                        description: "All the tools you need to create the rxbot using rxbot framework."
                    )

                    FeatureRow(
                        icon: "testtube.2",
                        title: "Testing support",
                        description: "Build and test your bot locally without any external services."
                    )

                    FeatureRow(
                        icon: "person.fill",
                        title: "Fridendly UI",
                        description: "User-friendly interface to make your bot building experience easier."
                    )
                }
                .padding(.horizontal, 30)

                Spacer()

                // Continue Button
                Button(action: {
                    document.hasInitialized = true
                    dismiss()
                }) {
                    Text("Continue")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                        )
                }
                .buttonStyle(.plain)
                .padding()
            }
            .padding(.vertical, 30)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SplashScreen(document: .constant(.init()))
        .frame(height: 800)
}
