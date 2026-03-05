import SwiftUI

struct MeasurementsFormSection: View {
    @Binding var heightCm: Int
    @Binding var weightKg: Int
    @Binding var age: Int
    var heightError: String? = nil
    var weightError: String? = nil
    var ageError: String? = nil

    var body: some View {
        FormCard(title: "Measurements", icon: "ruler.fill", iconColor: AppColors.secondary) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    StepperRow(
                        label: "Height",
                        value: $heightCm,
                        unit: "cm",
                        range: 60...210,
                        step: 1
                    )
                    if let error = heightError {
                        Text(error)
                            .font(.caption2)
                            .foregroundStyle(.red)
                            .padding(.leading, 4)
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    StepperRow(
                        label: "Weight",
                        value: $weightKg,
                        unit: "kg",
                        range: 8...120,
                        step: 1
                    )
                    if let error = weightError {
                        Text(error)
                            .font(.caption2)
                            .foregroundStyle(.red)
                            .padding(.leading, 4)
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    StepperRow(
                        label: "Age",
                        value: $age,
                        unit: "years",
                        range: 2...99,
                        step: 1
                    )
                    if let error = ageError {
                        Text(error)
                            .font(.caption2)
                            .foregroundStyle(.red)
                            .padding(.leading, 4)
                    }
                }
            }
        }
    }
}

struct AbilityFormSection: View {
    @Binding var abilityLevel: AbilityLevel

    var body: some View {
        FormCard(title: "Ability Level", icon: "star.fill", iconColor: AppColors.warning) {
            VStack(spacing: 10) {
                ForEach(AbilityLevel.allCases, id: \.self) { level in
                    AbilityRow(
                        level: level,
                        isSelected: abilityLevel == level
                    ) {
                        abilityLevel = level
                    }
                }
            }
            .sensoryFeedback(.selection, trigger: abilityLevel)
        }
    }
}

struct SkiTypeFormSection: View {
    @Binding var selectedSkiTypes: Set<SkiType>
    var skiTypeError: String? = nil

    var body: some View {
        FormCard(title: "Ski Type", icon: "snowflake", iconColor: AppColors.primary) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(SkiType.allCases, id: \.self) { type in
                    SkiTypeRow(
                        type: type,
                        isSelected: selectedSkiTypes.contains(type)
                    ) {
                        if selectedSkiTypes.contains(type) {
                            selectedSkiTypes.remove(type)
                        } else {
                            selectedSkiTypes.insert(type)
                        }
                    }
                }
                if let error = skiTypeError {
                    Text(error)
                        .font(.caption2)
                        .foregroundStyle(.red)
                        .padding(.leading, 4)
                }
            }
            .sensoryFeedback(.selection, trigger: selectedSkiTypes)
        }
    }
}

struct BSLFormSection: View {
    @Binding var bslInputMode: BSLInputMode
    @Binding var bslMm: Int
    @Binding var shoeSize: Int
    @Binding var footLengthMm: Int
    var bslError: String? = nil
    var footLengthError: String? = nil

    private var footLengthDisplay: String {
        String(format: "%.1f", Double(footLengthMm) / 10.0)
    }

    var body: some View {
        FormCard(title: "Boot Sole Length", icon: "shoe.fill", iconColor: AppColors.secondary) {
            VStack(alignment: .leading, spacing: 14) {
                Picker("Boot Info", selection: $bslInputMode) {
                    ForEach(BSLInputMode.allCases, id: \.self) { mode in
                        Text(mode.label).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 8)

                switch bslInputMode {
                case .bsl:
                    StepperRow(label: "Boot Sole Length", value: $bslMm, unit: "mm", range: 150...380, step: 5, icon: "shoe.fill", iconColor: Color(hex: "795548"))
                    if let error = bslError {
                        Text(error)
                            .font(.caption2)
                            .foregroundStyle(.red)
                            .padding(.leading, 4)
                    }
                    Text("Found printed on the boot sole or inside the boot")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                case .footLength:
                    StepperRow(label: "Foot Length", value: $footLengthMm, unit: "mm", range: 100...310, step: 5, icon: "ruler.fill", iconColor: Color(hex: "795548"))
                    if let error = footLengthError {
                        Text(error)
                            .font(.caption2)
                            .foregroundStyle(.red)
                            .padding(.leading, 4)
                    }
                    Text("\(footLengthDisplay) cm — Measure heel to longest toe. This equals the Mondo Point size.")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                case .shoeSize:
                    StepperRow(label: "EU Shoe Size", value: $shoeSize, unit: "EU", range: 15...50, step: 1, icon: "shoe.fill", iconColor: Color(hex: "795548"))
                    Text("Used to estimate boot sole length")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                case .estimate:
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                            .foregroundStyle(AppColors.textSecondary)
                        Text("Boot sole length will be estimated from height. For accurate DIN, provide BSL, foot length, or shoe size.")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
        }
    }
}
