import SwiftUI

struct DINDetailView: View {
    let dinResult: DINResult
    let childName: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        dinValueHero
                        explanationSection
                        tableSection
                        adjustmentsSection
                        safetyDisclaimer
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("DIN Detail")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.primary)
                }
            }
        }
    }

    private var dinValueHero: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.warning, AppColors.warning.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: AppColors.warning.opacity(0.4), radius: 12, x: 0, y: 6)

                VStack(spacing: 0) {
                    Text(dinResult.formattedValue)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("DIN")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.85))
                }
            }

            VStack(spacing: 4) {
                Text("Recommended for \(childName)")
                    .font(.headline)
                    .foregroundStyle(AppColors.textPrimary)

                HStack(spacing: 12) {
                    TagBadge(text: "Code \(dinResult.code)", color: AppColors.primary)
                    TagBadge(text: dinResult.skierType, color: AppColors.secondary)
                    if dinResult.isJuniorAdjusted {
                        TagBadge(text: "Junior (code shift)", color: AppColors.warning)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
    }

    private var explanationSection: some View {
        InfoCard(title: "What is DIN?", icon: "questionmark.circle.fill", iconColor: AppColors.primary) {
            VStack(alignment: .leading, spacing: 8) {
                Text("DIN (Deutsches Institut für Normung) is the release force setting on alpine ski bindings. It controls how easily the binding releases during a fall to prevent injury.")
                    .font(.body)
                    .foregroundStyle(AppColors.textPrimary)

                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundStyle(AppColors.secondary)
                    Text("Too low: skis release too easily during normal skiing")
                        .font(.callout)
                        .foregroundStyle(AppColors.textSecondary)
                }

                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundStyle(AppColors.accent)
                    Text("Too high: skis don't release in a dangerous fall — risk of injury")
                        .font(.callout)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }

    private var tableSection: some View {
        InfoCard(title: "How Your DIN Was Calculated", icon: "function", iconColor: AppColors.secondary) {
            VStack(alignment: .leading, spacing: 12) {
                DINStepRow(step: "1", title: "Weight → Code", detail: "Your child's weight determined the base code \(dinResult.code)")
                DINStepRow(step: "2", title: "Height Adjustment", detail: "Height was checked against code thresholds to ensure safe release")
                DINStepRow(step: "3", title: "Skier Type", detail: "\(dinResult.skierType) — based on ability level")
                if dinResult.isJuniorAdjusted {
                    DINStepRow(step: "4", title: "Junior Adjustment", detail: "DIN code shifted one level lower for children aged 9 and under, per ISO 11088")
                }
                DINStepRow(step: dinResult.isJuniorAdjusted ? "5" : "4", title: "Round to 0.25", detail: "Final value rounded to nearest 0.25 increment")
            }
        }
    }

    @ViewBuilder
    private var adjustmentsSection: some View {
        if !dinResult.warnings.isEmpty {
            InfoCard(title: "Additional Warnings", icon: "exclamationmark.triangle.fill", iconColor: AppColors.warning) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(dinResult.warnings, id: \.self) { warning in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(AppColors.warning)
                                .font(.caption)
                                .padding(.top, 2)
                            Text(warning)
                                .font(.callout)
                                .foregroundStyle(AppColors.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }

    private var safetyDisclaimer: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "shield.checkered")
                    .foregroundStyle(AppColors.warning)
                    .font(.title3)
                Text("Important Safety Notice")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textPrimary)
            }

            Text("DIN release values shown are recommendations based on the ISO 11088 standard lookup table. They must be verified and set by a certified ski technician. Incorrect DIN settings can result in serious injury. The app developer and publisher accept no liability for binding settings applied without professional verification.")
                .font(.body)
                .foregroundStyle(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            Text("Always have bindings professionally adjusted at the start of each season and whenever measurements change significantly.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(AppColors.warning)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(AppColors.warning.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.warning.opacity(0.4), lineWidth: 1.5)
        )
    }
}

struct TagBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

struct InfoCard<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)
            }
            content
        }
        .padding(16)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

struct DINStepRow: View {
    let step: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.12))
                    .frame(width: 28, height: 28)
                Text(step)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.primary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
    }
}
