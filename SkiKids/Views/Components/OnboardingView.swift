import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0

    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage(
                icon: "figure.skiing.downhill",
                iconColor: AppColors.primary,
                title: "Welcome to SkiKids",
                subtitle: "Find the perfect ski equipment for your child",
                gradient: [AppColors.primary, AppColors.secondary],
                action: nil,
                actionLabel: nil
            )
            .tag(0)

            OnboardingPage(
                icon: "ruler.fill",
                iconColor: AppColors.secondary,
                title: "Enter Measurements",
                subtitle: "Height, weight, age, and ability level — we calculate ski lengths, pole lengths, and DIN settings",
                gradient: [AppColors.secondary, Color(hex: "00695C")],
                action: nil,
                actionLabel: nil
            )
            .tag(1)

            OnboardingPage(
                icon: "shield.checkered",
                iconColor: AppColors.accent,
                title: "Safety Matters",
                subtitle: "DIN settings are recommendations only. Always have bindings set by a certified technician.",
                gradient: [AppColors.accent, Color(hex: "E65100")],
                action: { hasSeenOnboarding = true },
                actionLabel: "Get Started"
            )
            .tag(2)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .ignoresSafeArea()
    }
}

private struct OnboardingPage: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let gradient: [Color]
    let action: (() -> Void)?
    let actionLabel: String?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 140, height: 140)

                    Image(systemName: icon)
                        .font(.system(size: 64))
                        .foregroundStyle(.white)
                }
                .accessibilityHidden(true)

                VStack(spacing: 16) {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Text(subtitle)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                if let action, let label = actionLabel {
                    Button(action: action) {
                        Text(label)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(gradient.first ?? AppColors.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
                    .accessibilityLabel(label)
                    .accessibilityHint("Dismisses the introduction and opens the app")
                    .accessibilityAddTraits(.isButton)
                } else {
                    Color.clear
                        .frame(height: 60)
                        .padding(.bottom, 60)
                }
            }
        }
    }
}
