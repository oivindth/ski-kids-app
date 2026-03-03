import SwiftUI

struct ResultsView: View {
    let recommendation: SkiRecommendation
    let existingChild: Child?
    let onSave: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showingDINDetail = false
    @State private var savedProfile = false

    private var childName: String {
        recommendation.child.name.isEmpty ? "Your Child" : recommendation.child.name
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    warningsSection
                    alpineSection
                    xcSection
                    poleSection
                    disclaimerSection
                    if existingChild == nil && !savedProfile {
                        saveButton
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingDINDetail) {
            if let din = recommendation.dinResult {
                DINDetailView(dinResult: din, childName: childName)
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(childName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.textPrimary)

                    HStack(spacing: 16) {
                        Label("\(recommendation.child.heightCm) cm", systemImage: "ruler")
                        Label("\(recommendation.child.weightKg) kg", systemImage: "scalemass")
                        Label("\(recommendation.child.age) yrs", systemImage: "birthday.cake")
                    }
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(recommendation.child.abilityLevel.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(AppColors.primary.opacity(0.1))
                        .clipShape(Capsule())

                    Text(recommendation.calculatedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption2)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .padding(16)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    @ViewBuilder
    private var warningsSection: some View {
        if !recommendation.warnings.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(AppColors.warning)
                    Text("Notes")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textPrimary)
                }

                ForEach(recommendation.warnings, id: \.self) { warning in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(AppColors.warning)
                            .frame(width: 6, height: 6)
                            .padding(.top, 5)
                        Text(warning)
                            .font(.caption)
                            .foregroundStyle(AppColors.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(14)
            .background(AppColors.warning.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(AppColors.warning.opacity(0.3), lineWidth: 1)
            )
        }
    }

    @ViewBuilder
    private var alpineSection: some View {
        if recommendation.alpineSkiLength != nil || recommendation.dinResult != nil {
            VStack(spacing: 12) {
                SectionHeader(
                    title: "Alpine / Downhill",
                    icon: "figure.skiing.downhill",
                    color: AppColors.primary
                )

                if let alpine = recommendation.alpineSkiLength {
                    RecommendationCard(
                        title: "Ski Length",
                        subtitle: "Height-based sizing",
                        value: alpine.displayRange,
                        icon: "arrow.up.and.down",
                        color: AppColors.primary,
                        detail: nil
                    )

                    SkiLengthVisual(
                        minCm: alpine.minCm,
                        maxCm: alpine.maxCm,
                        heightCm: recommendation.child.heightCm,
                        color: AppColors.primary
                    )

                    Text("Younger/lighter children should choose softer-flex skis at the lower end of the range. Heavier or more advanced children can use the upper end.")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .padding(.horizontal, 4)
                }

                if let din = recommendation.dinResult {
                    Button {
                        showingDINDetail = true
                    } label: {
                        DINCard(dinResult: din)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    private var xcSection: some View {
        if recommendation.xcClassicLength != nil || recommendation.xcSkateLength != nil {
            VStack(spacing: 12) {
                SectionHeader(
                    title: "Cross-Country",
                    icon: "figure.skiing.crosscountry",
                    color: AppColors.secondary
                )

                if let classic = recommendation.xcClassicLength {
                    RecommendationCard(
                        title: "Classic Ski Length",
                        subtitle: "For kick-and-glide technique",
                        value: classic.displayRange,
                        icon: "figure.skiing.crosscountry",
                        color: AppColors.secondary,
                        detail: nil
                    )

                    SkiLengthVisual(
                        minCm: classic.minCm,
                        maxCm: classic.maxCm,
                        heightCm: recommendation.child.heightCm,
                        color: AppColors.secondary
                    )
                }

                if let skate = recommendation.xcSkateLength {
                    RecommendationCard(
                        title: "Skate Ski Length",
                        subtitle: "For skating technique",
                        value: skate.displayRange,
                        icon: "figure.skating",
                        color: AppColors.secondary,
                        detail: nil
                    )

                    if recommendation.child.age < 7 {
                        InfoBanner(
                            text: "Skate skiing poles are suitable for children 7 years and older who have mastered classic technique.",
                            color: AppColors.warning
                        )
                    }
                }

                InfoBanner(
                    text: "Make sure boots and bindings use the same system: NNN (Rottefella) or SNS/Prolink (Salomon). These are NOT interchangeable.",
                    color: AppColors.secondary
                )
            }
        }
    }

    @ViewBuilder
    private var poleSection: some View {
        let hasPoles = recommendation.alpinePoleLength != nil
            || recommendation.xcClassicPoleLength != nil
            || recommendation.xcSkatePoleLength != nil

        if hasPoles {
            VStack(spacing: 12) {
                SectionHeader(
                    title: "Pole Lengths",
                    icon: "arrow.up.and.down.and.sparkles",
                    color: Color(hex: "9C27B0")
                )

                if let alpine = recommendation.alpinePoleLength {
                    RecommendationCard(
                        title: "Alpine Poles",
                        subtitle: "Height × 0.68",
                        value: "\(alpine) cm",
                        icon: "arrow.up.and.down",
                        color: AppColors.primary,
                        detail: "Grip pole upside down below the basket — elbow should form a 90° angle."
                    )
                }

                if let classic = recommendation.xcClassicPoleLength {
                    RecommendationCard(
                        title: "XC Classic Poles",
                        subtitle: "Height × 0.83",
                        value: "\(classic) cm",
                        icon: "arrow.up.and.down",
                        color: AppColors.secondary,
                        detail: "Tip should reach the skier's armpit when standing normally."
                    )
                }

                if let skate = recommendation.xcSkatePoleLength {
                    RecommendationCard(
                        title: "XC Skate Poles",
                        subtitle: "Height × 0.88",
                        value: "\(skate) cm",
                        icon: "arrow.up.and.down",
                        color: AppColors.secondary,
                        detail: "Tip should reach between chin and nose when standing."
                    )
                }
            }
        }
    }

    private var disclaimerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "shield.fill")
                    .foregroundStyle(AppColors.warning)
                    .font(.subheadline)
                Text("Safety Disclaimer")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)
            }

            Text("DIN release values shown are recommendations based on the ISO 11088 standard lookup table. They must be verified and set by a certified ski technician. Incorrect DIN settings can result in serious injury. The app developer and publisher accept no liability for binding settings applied without professional verification.")
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(AppColors.warning.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppColors.warning.opacity(0.25), lineWidth: 1)
        )
    }

    private var saveButton: some View {
        Button {
            onSave()
            savedProfile = true
        } label: {
            HStack {
                Image(systemName: "person.badge.plus")
                Text("Save Profile")
                    .fontWeight(.bold)
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: AppColors.primary.opacity(0.35), radius: 8, x: 0, y: 4)
        }
        .overlay(
            savedProfile
                ? RoundedRectangle(cornerRadius: 16)
                    .fill(Color.clear)
                : nil
        )
        .disabled(savedProfile)
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(color)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textPrimary)
            Spacer()
        }
    }
}

struct InfoBanner: View {
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle.fill")
                .font(.caption)
                .foregroundStyle(color)
                .padding(.top, 1)
            Text(text)
                .font(.caption)
                .foregroundStyle(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .background(color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct DINCard: View {
    let dinResult: DINResult

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "dial.medium.fill")
                        .foregroundStyle(AppColors.warning)
                    Text("DIN Setting")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textPrimary)
                }

                Text("Code \(dinResult.code) · \(dinResult.skierType)")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)

                if dinResult.isJuniorAdjusted {
                    Text("Junior adjustment applied")
                        .font(.caption2)
                        .foregroundStyle(AppColors.warning)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(dinResult.formattedValue)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.warning)

                Text("tap for details")
                    .font(.caption2)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(16)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.warning.opacity(0.4), lineWidth: 1.5)
        )
        .shadow(color: AppColors.warning.opacity(0.12), radius: 8, x: 0, y: 3)
    }
}
