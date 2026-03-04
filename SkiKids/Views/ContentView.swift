import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("My Kids", systemImage: "person.2.fill")
                }

            QuickCalcView()
                .tabItem {
                    Label("Quick Calc", systemImage: "bolt.fill")
                }

            TipsView()
                .tabItem {
                    Label("Tips & Info", systemImage: "info.circle.fill")
                }
        }
        .tint(AppColors.primary)
        .preferredColorScheme(appearanceMode.colorScheme)
        .fullScreenCover(isPresented: Binding(
            get: { !hasSeenOnboarding },
            set: { if !$0 { hasSeenOnboarding = true } }
        )) {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
}

enum AppColors {
    static let primary = Color(hex: "1A73E8")
    static let secondary = Color(hex: "00897B")
    static let accent = Color(hex: "FF6D00")
    static let background = Color.adaptive(light: Color(hex: "F5F7FA"), dark: Color(hex: "1A1A2E"))
    static let surface = Color.adaptive(light: .white, dark: Color(hex: "2A2A3E"))
    static let textPrimary = Color.adaptive(light: Color(hex: "1A1A2E"), dark: Color(hex: "F0F0F5"))
    static let textSecondary = Color.adaptive(light: Color(hex: "6B7280"), dark: Color(hex: "9CA3AF"))
    static let warning = Color(hex: "F59E0B")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}
