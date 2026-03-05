import SwiftUI

struct ResultsView: View {
    let recommendation: SkiRecommendation
    let existingChild: Child?
    var onSave: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var showingDINDetail = false
    @State private var savedProfile = false
    @State private var showingShopMode = false

    private var childName: String {
        recommendation.child.name.isEmpty ? "Your Child" : recommendation.child.name
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    Button {
                        showingShopMode = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "storefront")
                                .font(.body)
                            Text("Show to Ski Shop")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(AppColors.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppColors.primary.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    warningsSection
                    alpineSection
                    xcSection
                    poleSection
                    equipmentGuideSection
                    disclaimerSection
                    if let onSave, existingChild == nil && !savedProfile {
                        saveButton(onSave: onSave)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: recommendation.shareText) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(AppColors.primary)
                }
            }
        }
        .sheet(isPresented: $showingDINDetail) {
            if let din = recommendation.dinResult {
                DINDetailView(dinResult: din, childName: childName)
            }
        }
        .fullScreenCover(isPresented: $showingShopMode) {
            SkiShopModeView(recommendation: recommendation)
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

                    InfoBanner(
                        text: "Classic ski length also depends on weight. Lighter children may need shorter/softer skis to compress the kick zone properly.",
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

                    if recommendation.child.age < 8 {
                        InfoBanner(
                            text: "Skate skiing is recommended for children 8 years and older who have mastered classic technique.",
                            color: AppColors.warning
                        )
                    }
                }

                InfoBanner(
                    text: "NNN (Rottefella), Prolink (Salomon/Atomic), and Turnamic (Fischer) are cross-compatible. Only legacy SNS bindings require SNS-specific boots.",
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
                        subtitle: "Height × 0.84",
                        value: "\(classic) cm",
                        icon: "arrow.up.and.down",
                        color: AppColors.secondary,
                        detail: "Tip should reach between armpit and shoulder when standing normally."
                    )
                }

                if let skate = recommendation.xcSkatePoleLength {
                    RecommendationCard(
                        title: "XC Skate Poles",
                        subtitle: "Height × 0.89",
                        value: "\(skate) cm",
                        icon: "arrow.up.and.down",
                        color: AppColors.secondary,
                        detail: "Tip should reach between chin and nose when standing."
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var equipmentGuideSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Equipment Guide", icon: "bag.fill", color: Color(hex: "795548"))
            bootSizingCard
            helmetGuideCard(age: recommendation.child.age)
        }
    }

    private var bootSizingCard: some View {
        let boot = recommendation.bootSizeRecommendation
        let bootColor = Color(hex: "795548")

        return VStack(alignment: .leading, spacing: 14) {
            // Header with confidence badge
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(bootColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: "shoe.2.fill")
                        .font(.body)
                        .foregroundStyle(bootColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Ski Boot Sizing")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textPrimary)
                    Text(boot.confidence.rawValue)
                        .font(.caption2)
                        .foregroundStyle(bootColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(bootColor.opacity(0.1))
                        .clipShape(Capsule())
                }

                Spacer()
            }

            // Key specs grid
            VStack(spacing: 0) {
                if boot.confidence != .hasBoots {
                    bootSpecRow(
                        label: "Boot Size",
                        value: "Mondo \(boot.recommendedMondoCm)",
                        secondary: "EU \(boot.euSize)",
                        showDivider: true
                    )
                }

                bootSpecRow(
                    label: "Boot Sole Length",
                    value: "\(boot.estimatedBSL) mm",
                    secondary: boot.confidence == .hasBoots ? "entered directly" : "for DIN binding setup",
                    showDivider: boot.confidence != .hasBoots && boot.growthRoomMm > 0
                )

                if boot.confidence != .hasBoots && boot.growthRoomMm > 0 {
                    bootSpecRow(
                        label: "Growth Room",
                        value: "+\(boot.growthRoomCm) cm",
                        secondary: "foot \(boot.measuredFootCm) cm → boot \(boot.recommendedMondoCm) cm",
                        showDivider: false
                    )
                }
            }
            .padding(12)
            .background(bootColor.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Contextual tip
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.caption)
                    .foregroundStyle(bootColor)
                    .padding(.top, 1)
                Text(bootTip(confidence: boot.confidence))
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    private func bootSpecRow(label: String, value: String, secondary: String, showDivider: Bool) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
                VStack(alignment: .trailing, spacing: 1) {
                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.textPrimary)
                    Text(secondary)
                        .font(.caption2)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .padding(.vertical, 8)

            if showDivider {
                Divider()
            }
        }
    }

    private func bootTip(confidence: BootSizeConfidence) -> String {
        switch confidence {
        case .measured:
            return "Ski boots should fit snugly — never buy more than 1.5 cm too large. BSL is printed on the boot sole; verify after purchase for accurate DIN settings."
        case .fromShoeSize:
            return "Boot size is approximate — street shoe sizes vary by brand. For best results, measure foot length in cm (heel to longest toe) or try boots on in store."
        case .fromHeight:
            return "This is a rough estimate. For accurate boot sizing, measure foot length in cm or enter EU shoe size in the calculator."
        case .hasBoots:
            return "BSL is used to calculate your DIN binding release setting. Verify the BSL matches the number printed on your boot sole."
        }
    }

    private func helmetGuideCard(age: Int) -> some View {
        let sizeGuide: String
        if age <= 3 { sizeGuide = "47–51 cm (XS)" }
        else if age <= 6 { sizeGuide = "51–55 cm (S)" }
        else if age <= 11 { sizeGuide = "55–59 cm (M)" }
        else { sizeGuide = "55–62 cm (M/L)" }

        return RecommendationCard(
            title: "Helmet Size (estimate)",
            subtitle: "Based on typical age range",
            value: sizeGuide,
            icon: "bicycle.helmet",
            color: Color(hex: "9C27B0"),
            detail: "Head sizes vary widely at the same age. Measure head circumference for accurate sizing. Never buy a helmet with room to grow."
        )
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

    private func saveButton(onSave: @escaping () -> Void) -> some View {
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

struct SkiShopModeView: View {
    let recommendation: SkiRecommendation
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Text(recommendation.child.name.isEmpty ? "Child" : recommendation.child.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(AppColors.textPrimary)

                        HStack(spacing: 20) {
                            shopStat("Height", "\(recommendation.child.heightCm) cm")
                            shopStat("Weight", "\(recommendation.child.weightKg) kg")
                            shopStat("Age", "\(recommendation.child.age)")
                        }

                        Divider().padding(.horizontal, 20)

                        VStack(spacing: 20) {
                            if let alpine = recommendation.alpineSkiLength {
                                shopRow("Alpine Skis", alpine.displayRange, "figure.skiing.downhill", AppColors.primary)
                            }
                            if let din = recommendation.dinResult {
                                shopRow("DIN Setting", din.formattedValue, "dial.medium.fill", AppColors.warning)
                            }
                            if let classic = recommendation.xcClassicLength {
                                shopRow("XC Classic", classic.displayRange, "figure.skiing.crosscountry", AppColors.secondary)
                            }
                            if let skate = recommendation.xcSkateLength {
                                shopRow("XC Skate", skate.displayRange, "figure.skating", AppColors.secondary)
                            }
                            if let pole = recommendation.alpinePoleLength {
                                shopRow("Alpine Poles", "\(pole) cm", "arrow.up.and.down", AppColors.primary)
                            }
                            if let pole = recommendation.xcClassicPoleLength {
                                shopRow("XC Classic Poles", "\(pole) cm", "arrow.up.and.down", AppColors.secondary)
                            }
                            if let pole = recommendation.xcSkatePoleLength {
                                shopRow("XC Skate Poles", "\(pole) cm", "arrow.up.and.down", AppColors.secondary)
                            }
                            let boot = recommendation.bootSizeRecommendation
                            if boot.confidence != .hasBoots {
                                shopRow("Boot Size", "Mondo \(boot.recommendedMondoCm) (EU \(boot.euSize))", "shoe.2.fill", Color(hex: "795548"))
                            }
                            shopRow("BSL", "\(boot.estimatedBSL) mm", "ruler.fill", Color(hex: "795548"))
                        }
                        .padding(.horizontal, 20)

                        if recommendation.dinResult != nil {
                            Text("DIN must be set by a certified technician")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppColors.warning)
                                .multilineTextAlignment(.center)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Ski Shop")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.primary)
                }
            }
        }
    }

    private func shopStat(_ label: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundStyle(AppColors.textPrimary)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private func shopRow(_ label: String, _ value: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 36)

            Text(label)
                .font(.title3)
                .foregroundStyle(AppColors.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.textPrimary)
        }
        .padding(.vertical, 8)
    }
}
