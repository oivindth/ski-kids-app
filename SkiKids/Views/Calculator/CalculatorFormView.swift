import SwiftUI
import SwiftData

struct CalculatorFormView: View {
    let existingChild: Child?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CalculatorViewModel()
    @State private var childViewModel = ChildViewModel()
    @State private var showingResults = false
    @State private var validationAlert = false

    private var isEditing: Bool { existingChild != nil }

    private var title: String {
        if let child = existingChild, !child.name.isEmpty {
            return child.name
        }
        return isEditing ? "Edit Child" : "Add Child"
    }

    var body: some View {
        let content = formContent
        if isEditing {
            content
        } else {
            NavigationStack {
                content
            }
        }
    }

    private var formContent: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    nameSection
                    measurementsSection
                    abilitySection
                    skiTypeSection
                    bslSection
                    calculateButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if isEditing {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.primary)
                }
            } else {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .onAppear {
            if let child = existingChild {
                viewModel.populate(from: child)
            }
        }
        .navigationDestination(isPresented: $showingResults) {
            if let rec = viewModel.recommendation {
                ResultsView(
                    recommendation: rec,
                    existingChild: existingChild,
                    onSave: { saveFromResults() }
                )
            }
        }
        .alert("Please fix the following", isPresented: $validationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.validationErrors.joined(separator: "\n"))
        }
    }

    private var nameSection: some View {
        FormCard(title: "Child Name", icon: "person.fill", iconColor: AppColors.primary) {
            TextField("Name (optional)", text: $viewModel.name)
                .font(.body)
                .padding(.horizontal, 4)
        }
    }

    private var measurementsSection: some View {
        FormCard(title: "Measurements", icon: "ruler.fill", iconColor: AppColors.secondary) {
            VStack(spacing: 16) {
                StepperRow(
                    label: "Height",
                    value: $viewModel.heightCm,
                    unit: "cm",
                    range: 60...200,
                    step: 1
                )

                Divider()

                StepperRow(
                    label: "Weight",
                    value: $viewModel.weightKg,
                    unit: "kg",
                    range: 8...80,
                    step: 1
                )

                Divider()

                StepperRow(
                    label: "Age",
                    value: $viewModel.age,
                    unit: "years",
                    range: 2...17,
                    step: 1
                )
            }
        }
    }

    private var abilitySection: some View {
        FormCard(title: "Ability Level", icon: "star.fill", iconColor: AppColors.warning) {
            VStack(spacing: 10) {
                ForEach(AbilityLevel.allCases, id: \.self) { level in
                    AbilityRow(
                        level: level,
                        isSelected: viewModel.abilityLevel == level
                    ) {
                        viewModel.abilityLevel = level
                    }
                }
            }
        }
    }

    private var skiTypeSection: some View {
        FormCard(title: "Ski Type", icon: "snowflake", iconColor: AppColors.primary) {
            VStack(spacing: 10) {
                ForEach(SkiType.allCases, id: \.self) { type in
                    SkiTypeRow(
                        type: type,
                        isSelected: viewModel.selectedSkiTypes.contains(type)
                    ) {
                        if viewModel.selectedSkiTypes.contains(type) {
                            viewModel.selectedSkiTypes.remove(type)
                        } else {
                            viewModel.selectedSkiTypes.insert(type)
                        }
                    }
                }
            }
        }
    }

    private var bslSection: some View {
        FormCard(title: "Boot Sole Length", icon: "shoe.fill", iconColor: AppColors.secondary) {
            VStack(alignment: .leading, spacing: 14) {
                Toggle("I know the BSL", isOn: $viewModel.hasBSL)
                    .tint(AppColors.primary)

                if viewModel.hasBSL {
                    StepperRow(
                        label: "BSL",
                        value: $viewModel.bslMm,
                        unit: "mm",
                        range: 150...330,
                        step: 5
                    )
                } else {
                    Toggle("I know the EU shoe size", isOn: $viewModel.hasShoeSize)
                        .tint(AppColors.primary)

                    if viewModel.hasShoeSize {
                        StepperRow(
                            label: "EU Shoe Size",
                            value: $viewModel.shoeSize,
                            unit: "",
                            range: 15...42,
                            step: 1
                        )
                        Text("BSL will be estimated from shoe size EU \(viewModel.shoeSize).")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text("BSL will be estimated from height. Provide the actual Boot Sole Length (printed inside the boot) or EU shoe size for accurate DIN results.")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private var calculateButton: some View {
        Button {
            if viewModel.isValid {
                viewModel.calculate()
                if let child = existingChild {
                    childViewModel.updateLastCalculated(for: child, context: modelContext)
                }
                showingResults = true
            } else {
                validationAlert = true
            }
        } label: {
            HStack {
                Image(systemName: "wand.and.stars")
                Text("Calculate Recommendations")
                    .fontWeight(.bold)
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [AppColors.accent, Color(hex: "E65100")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: AppColors.accent.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .padding(.top, 4)
    }

    private func saveProfile() {
        childViewModel.saveChild(
            existingChild,
            name: viewModel.name,
            heightCm: viewModel.heightCm,
            weightKg: viewModel.weightKg,
            age: viewModel.age,
            bslMm: viewModel.hasBSL ? viewModel.bslMm : nil,
            abilityLevel: viewModel.abilityLevel,
            skiTypes: Array(viewModel.selectedSkiTypes),
            context: modelContext
        )
        dismiss()
    }

    private func saveFromResults() {
        if existingChild == nil {
            childViewModel.saveChild(
                nil,
                name: viewModel.name,
                heightCm: viewModel.heightCm,
                weightKg: viewModel.weightKg,
                age: viewModel.age,
                bslMm: viewModel.hasBSL ? viewModel.bslMm : nil,
                abilityLevel: viewModel.abilityLevel,
                skiTypes: Array(viewModel.selectedSkiTypes),
                context: modelContext
            )
        }
    }
}

struct FormCard<Content: View>: View {
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

struct StepperRow: View {
    let label: String
    @Binding var value: Int
    let unit: String
    let range: ClosedRange<Int>
    let step: Int

    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundStyle(AppColors.textPrimary)

            Spacer()

            HStack(spacing: 12) {
                Button {
                    if value - step >= range.lowerBound {
                        value -= step
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppColors.primary)
                }

                Text("\(value) \(unit)")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(minWidth: 80, alignment: .center)

                Button {
                    if value + step <= range.upperBound {
                        value += step
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppColors.primary)
                }
            }
        }
    }
}

struct AbilityRow: View {
    let level: AbilityLevel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? AppColors.primary : AppColors.textSecondary.opacity(0.3), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: 12, height: 12)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(level.rawValue)
                        .font(.body)
                        .fontWeight(isSelected ? .semibold : .regular)
                        .foregroundStyle(isSelected ? AppColors.primary : AppColors.textPrimary)

                    Text(level.description)
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
        }
        .padding(10)
        .background(isSelected ? AppColors.primary.opacity(0.06) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SkiTypeRow: View {
    let type: SkiType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AppColors.primary : AppColors.textSecondary.opacity(0.4))

                Image(systemName: type.icon)
                    .font(.body)
                    .foregroundStyle(AppColors.secondary)
                    .frame(width: 24)

                Text(type.rawValue)
                    .font(.body)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(isSelected ? AppColors.primary : AppColors.textPrimary)

                Spacer()
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
    }
}
