import SwiftUI

struct TipsView: View {
    @State private var expandedSection: TipsSection?

    enum TipsSection: String, CaseIterable {
        case measuring = "How to Measure"
        case alpineEquip = "Alpine Equipment"
        case xcEquip = "Cross-Country Equipment"
        case helmet = "Helmet Sizing"
        case boots = "Boot Fitting"
        case din = "Understanding DIN"
        case wax = "Kick Wax Guide"
        case checklist = "Packing Essentials"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        headerBanner

                        ForEach(TipsSection.allCases, id: \.self) { section in
                            TipsAccordion(
                                section: section,
                                isExpanded: expandedSection == section
                            ) {
                                if expandedSection == section {
                                    expandedSection = nil
                                } else {
                                    expandedSection = section
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Tips & Info")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var headerBanner: some View {
        HStack(spacing: 14) {
            Image(systemName: "mountain.2.fill")
                .font(.title)
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 4) {
                Text("Ski Equipment Guide")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Expert tips from certified ski instructors and shops.")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.85))
            }

            Spacer()
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: AppColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct TipsAccordion: View {
    let section: TipsView.TipsSection
    let isExpanded: Bool
    let toggle: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: toggle) {
                HStack(spacing: 12) {
                    Image(systemName: sectionIcon)
                        .font(.body)
                        .foregroundStyle(sectionColor)
                        .frame(width: 28)

                    Text(section.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textPrimary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textSecondary)
                }
                .padding(16)
            }
            .background(AppColors.surface)

            if isExpanded {
                Divider()
                    .padding(.horizontal, 16)

                sectionContent
                    .padding(16)
                    .background(AppColors.surface)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }

    private var sectionIcon: String {
        switch section {
        case .measuring: return "ruler"
        case .alpineEquip: return "figure.skiing.downhill"
        case .xcEquip: return "figure.skiing.crosscountry"
        case .helmet: return "helmet"
        case .boots: return "shoe.fill"
        case .din: return "dial.medium"
        case .wax: return "paintbrush.fill"
        case .checklist: return "checklist"
        }
    }

    private var sectionColor: Color {
        switch section {
        case .measuring: return AppColors.secondary
        case .alpineEquip: return AppColors.primary
        case .xcEquip: return AppColors.secondary
        case .helmet: return Color(hex: "9C27B0")
        case .boots: return Color(hex: "795548")
        case .din: return AppColors.warning
        case .wax: return AppColors.accent
        case .checklist: return AppColors.primary
        }
    }

    @ViewBuilder
    private var sectionContent: some View {
        switch section {
        case .measuring: measuringContent
        case .alpineEquip: alpineContent
        case .xcEquip: xcContent
        case .helmet: helmetContent
        case .boots: bootsContent
        case .din: dinContent
        case .wax: waxContent
        case .checklist: checklistContent
        }
    }

    private var measuringContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            TipText("Height: Measure without shoes, standing straight against a wall.")
            TipText("Weight: Use a home scale without clothing for accuracy.")
            TipText("Foot length (for boot sizing): Place foot on paper with heel against a wall. Mark the longest toe. Measure heel to mark in centimeters — this is your Mondo Point size.")
            TipText("Boot Sole Length (BSL): Found printed inside the ski boot. For best accuracy, read the BSL directly from inside the boot. The app can estimate from shoe size or height, but actual BSL gives the most precise DIN result.")
            TipText("Head circumference (for helmets): Measure around the widest part of the head, just above the eyebrows and ears.")
        }
    }

    private var alpineContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            TipText("Beginners: Shorter skis (chin to nose height) are easier to control and turn.")
            TipText("Intermediate: Nose to forehead height — provides a balance of control and performance.")
            TipText("Advanced: Forehead to top of head or taller — more speed and carving ability.")
            TipText("Soft flex: Better for lighter, younger children on easier terrain.")
            TipText("Stiff flex: Better for heavier, more advanced skiers at higher speeds.")
            TipText("Always have bindings set by a certified ski technician at the start of each season.")
        }
    }

    private var xcContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            TipText("Classic skis are longer and have a grip (kick) zone in the middle for pushing off.")
            TipText("Skate skis are shorter and have no kick zone — suitable for children 8+ who have mastered classic technique.")
            TipText("NNN (Rottefella), Prolink (Salomon/Atomic), and Turnamic (Fischer) bindings are cross-compatible — boots from any of these systems work together. Only legacy SNS bindings are NOT compatible with NNN/Prolink/Turnamic.")
            TipText("Waxable classic skis need kick wax applied based on snow temperature.")
            TipText("Waxless (fishscale) skis require no kick wax — ideal for beginners and recreational skiers.")
        }
    }

    private var helmetContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            TipText("Measure head circumference at the widest point (just above eyebrows and ears).")

            VStack(alignment: .leading, spacing: 6) {
                Text("Size Guide:")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)

                let sizes: [(String, String)] = [
                    ("48–52 cm", "XS / Kids S"),
                    ("52–55.5 cm", "S / Kids M"),
                    ("55.5–59 cm", "M / Kids L"),
                    ("59–62 cm", "L"),
                ]
                ForEach(sizes, id: \.0) { size in
                    HStack {
                        Text(size.0)
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .frame(width: 80, alignment: .leading)
                        Text(size.1)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
            }

            TipText("For head circumferences under 48 cm (typically toddlers), look for infant/toddler-specific helmets from specialty brands.")
            TipText("NEVER buy a helmet with room to grow. A loose helmet will not protect properly in a crash. It should fit snugly with no wobble.")
            TipText("Sizes vary between brands. Always check the specific manufacturer's size chart and try the helmet on before purchasing.")
            TipText("Fit check: Helmet should sit level, two finger-widths above the eyebrows. Chinstrap should be snug — only one finger should fit between strap and chin.")
            TipText("Look for certification: EN 1077 (Europe) or ASTM F2040 (USA).")
        }
    }

    private var bootsContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            TipText("Ski boots should NOT have the same room as regular shoes. Too much room causes poor control and blisters.")
            TipText("For children, 1–1.5 cm of growth room is appropriate. Never buy boots more than 1.5 cm too large.")

            VStack(alignment: .leading, spacing: 6) {
                Text("Growth Room Guide:")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)

                let guide: [(String, String)] = [
                    ("Under 6", "1.0–1.5 cm"),
                    ("6–10 years", "1.0–1.5 cm"),
                    ("10–14 years", "0.5–1.0 cm"),
                    ("14+", "0–0.5 cm"),
                ]
                ForEach(guide, id: \.0) { row in
                    HStack {
                        Text(row.0)
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .frame(width: 90, alignment: .leading)
                        Text(row.1)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Flex Rating for Alpine Boots:")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)

                let flex: [(String, String)] = [
                    ("50–60", "Beginner, ages 5–9"),
                    ("60–80", "Intermediate, ages 8–12"),
                    ("80–100", "Advanced/teen, ages 12+"),
                ]
                ForEach(flex, id: \.0) { row in
                    HStack {
                        Text(row.0)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.primary)
                            .frame(width: 60, alignment: .leading)
                        Text(row.1)
                            .font(.caption)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
            }

            TipText("Children ages 2–4 typically use soft-shell boots without a standard flex rating. Look for the softest option available in their size.")
        }
    }

    private var dinContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            TipText("DIN is the release force setting on alpine ski bindings. It controls how easily the binding releases in a fall.")
            TipText("Too low: Skis release during normal skiing. Too high: Skis don't release in a dangerous fall — injury risk.")
            TipText("Type I (Beginner): Prefers early release. Type II (Intermediate): Balanced. Type III (Advanced): Prefers retention.")
            TipText("Junior adjustment: Children aged 9 and under receive a one-code reduction in their DIN setting for added safety, per ISO 11088.")
            TipText("ALWAYS have bindings professionally set by a certified ski technician. Do not set DIN yourself based on app recommendations alone.")
        }
    }

    private var waxContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            TipText("Kick wax is only needed for classic XC skis. Waxless (fishscale) skis don't need it.")

            VStack(alignment: .leading, spacing: 6) {
                Text("Temperature Guide:")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)

                let waxGuide: [(String, String, Color)] = [
                    ("Above 0°C, old/icy snow", "Klister (red/universal)", .red),
                    ("0°C to +3°C, fresh snow", "Red/silver hard wax", Color(hex: "E53935")),
                    ("-1°C to -3°C", "Violet hard wax", .purple),
                    ("-3°C to -10°C", "Blue hard wax", AppColors.primary),
                    ("-10°C to -20°C", "Green hard wax", AppColors.secondary),
                    ("Below -20°C", "Polar wax (white/green)", Color(hex: "00897B")),
                ]
                ForEach(waxGuide, id: \.0) { row in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(row.2)
                            .frame(width: 10, height: 10)
                        Text(row.0)
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .frame(width: 140, alignment: .leading)
                        Text(row.1)
                            .font(.caption)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
            }

            TipText("Snow condition matters as much as temperature. Fresh snow generally uses harder (higher temperature) wax; old, transformed, or icy snow may need softer wax or klister.")
            TipText("Always check the wax manufacturer's specific temperature guide. Wax brands vary in their optimal temperature ranges.")
        }
    }

    private let checklistKeys: [String] = [
        "checklist_helmet",
        "checklist_goggles",
        "checklist_socks",
        "checklist_neck_gaiter",
        "checklist_din_checked",
        "checklist_xc_gloves",
        "checklist_xc_boots",
        "checklist_xc_wax",
    ]

    private var checklistContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("The easy-to-forget essentials")
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.bottom, 4)

            ChecklistItem(text: "Helmet (mandatory at most resorts)", storageKey: "checklist_helmet")
            ChecklistItem(text: "Goggles or sunglasses (UV protection)", storageKey: "checklist_goggles")
            ChecklistItem(text: "Ski socks — wool or synthetic, never cotton", storageKey: "checklist_socks")
            ChecklistItem(text: "Neck gaiter or balaclava", storageKey: "checklist_neck_gaiter")
            ChecklistTagItem(text: "Bindings DIN checked this season", tag: "Alpine", tagColor: AppColors.primary, storageKey: "checklist_din_checked")
            ChecklistTagItem(text: "Lighter XC-specific gloves", tag: "XC", tagColor: AppColors.secondary, storageKey: "checklist_xc_gloves")
            ChecklistTagItem(text: "Boots match binding system (NNN/Prolink)", tag: "XC", tagColor: AppColors.secondary, storageKey: "checklist_xc_boots")
            ChecklistTagItem(text: "Kick wax, or confirm skis are waxless", tag: "XC", tagColor: AppColors.secondary, storageKey: "checklist_xc_wax")

            Button("Reset Checklist") {
                for key in checklistKeys {
                    UserDefaults.standard.removeObject(forKey: key)
                }
            }
            .font(.caption)
            .foregroundStyle(AppColors.textSecondary)
            .padding(.top, 4)
        }
    }
}

struct TipText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption)
                .foregroundStyle(AppColors.secondary)
                .padding(.top, 2)
            Text(text)
                .font(.callout)
                .foregroundStyle(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct ChecklistTagItem: View {
    let text: String
    let tag: String
    let tagColor: Color
    let storageKey: String
    @AppStorage private var isChecked: Bool

    init(text: String, tag: String, tagColor: Color, storageKey: String) {
        self.text = text
        self.tag = tag
        self.tagColor = tagColor
        self.storageKey = storageKey
        self._isChecked = AppStorage(wrappedValue: false, storageKey)
    }

    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isChecked ? AppColors.secondary : AppColors.textSecondary.opacity(0.4))
                    .font(.body)

                Text(text)
                    .font(.callout)
                    .foregroundStyle(isChecked ? AppColors.textSecondary : AppColors.textPrimary)
                    .strikethrough(isChecked, color: AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Text(tag)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(tagColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(tagColor.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(text)
        .accessibilityValue(isChecked ? "Checked" : "Unchecked")
        .accessibilityAddTraits(.isToggle)
    }
}

struct ChecklistItem: View {
    let text: String
    let storageKey: String
    @AppStorage private var isChecked: Bool

    init(text: String, storageKey: String) {
        self.text = text
        self.storageKey = storageKey
        self._isChecked = AppStorage(wrappedValue: false, storageKey)
    }

    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isChecked ? AppColors.secondary : AppColors.textSecondary.opacity(0.4))
                    .font(.body)

                Text(text)
                    .font(.callout)
                    .foregroundStyle(isChecked ? AppColors.textSecondary : AppColors.textPrimary)
                    .strikethrough(isChecked, color: AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(text)
        .accessibilityValue(isChecked ? "Checked" : "Unchecked")
        .accessibilityAddTraits(.isToggle)
    }
}
