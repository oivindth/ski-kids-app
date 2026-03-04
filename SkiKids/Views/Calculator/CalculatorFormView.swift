import SwiftUI
import SwiftData

struct CalculatorFormView: View {
    let existingChild: Child?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CalculatorViewModel()
    @State private var childViewModel = ChildViewModel()
    @State private var showingResults = false

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
        .sensoryFeedback(.success, trigger: showingResults)
    }

    private var nameSection: some View {
        FormCard(title: "Child Name", icon: "person.fill", iconColor: AppColors.primary) {
            TextField("Name (optional)", text: $viewModel.name)
                .font(.body)
                .foregroundStyle(AppColors.textPrimary)
                .padding(.horizontal, 4)
        }
    }

    private var measurementsSection: some View {
        MeasurementsFormSection(
            heightCm: $viewModel.heightCm,
            weightKg: $viewModel.weightKg,
            age: $viewModel.age,
            heightError: viewModel.hasAttemptedCalculation ? viewModel.heightError : nil,
            weightError: viewModel.hasAttemptedCalculation ? viewModel.weightError : nil,
            ageError: viewModel.hasAttemptedCalculation ? viewModel.ageError : nil
        )
    }

    private var abilitySection: some View {
        AbilityFormSection(abilityLevel: $viewModel.abilityLevel)
    }

    private var skiTypeSection: some View {
        SkiTypeFormSection(
            selectedSkiTypes: $viewModel.selectedSkiTypes,
            skiTypeError: viewModel.hasAttemptedCalculation ? viewModel.skiTypeError : nil
        )
    }

    private var bslSection: some View {
        BSLFormSection(
            bslInputMode: $viewModel.bslInputMode,
            bslMm: $viewModel.bslMm,
            shoeSize: $viewModel.shoeSize,
            bslError: viewModel.hasAttemptedCalculation ? viewModel.bslError : nil
        )
    }

    private var calculateButton: some View {
        Button {
            viewModel.calculate()
            if viewModel.isValid {
                if let child = existingChild {
                    childViewModel.updateLastCalculated(for: child, context: modelContext)
                }
                showingResults = true
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
        .accessibilityLabel("Calculate Recommendations")
        .accessibilityHint("Calculates ski length, pole length, and DIN settings based on the entered measurements")
        .padding(.top, 4)
    }

    private func saveProfile() {
        childViewModel.saveChild(
            existingChild,
            name: viewModel.name,
            heightCm: viewModel.heightCm,
            weightKg: viewModel.weightKg,
            age: viewModel.age,
            bslMm: viewModel.bslInputMode == .bsl ? viewModel.bslMm : nil,
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
                bslMm: viewModel.bslInputMode == .bsl ? viewModel.bslMm : nil,
                abilityLevel: viewModel.abilityLevel,
                skiTypes: Array(viewModel.selectedSkiTypes),
                context: modelContext
            )
        }
        dismiss()
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
    let range: ClosedRange<Int>
    let step: Int
    let unit: String
    let icon: String
    let iconColor: Color

    @State private var isEditing = false
    @State private var editText = ""
    @FocusState private var textFieldFocused: Bool

    init(label: String, value: Binding<Int>, unit: String, range: ClosedRange<Int>, step: Int, icon: String = "", iconColor: Color = .clear) {
        self.label = label
        self._value = value
        self.unit = unit
        self.range = range
        self.step = step
        self.icon = icon
        self.iconColor = iconColor
    }

    var body: some View {
        HStack(spacing: 16) {
            if !icon.isEmpty {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(iconColor)
                    .frame(width: 24)
            }

            Text(label)
                .font(.subheadline)
                .foregroundStyle(AppColors.textPrimary)

            Spacer()

            HStack(spacing: 8) {
                Button {
                    if value - step >= range.lowerBound {
                        value -= step
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(value <= range.lowerBound ? AppColors.textSecondary.opacity(0.3) : AppColors.primary)
                }
                .frame(minWidth: 44, minHeight: 44)
                .disabled(value <= range.lowerBound)

                if isEditing {
                    TextField("", text: $editText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .font(.system(.body, design: .rounded, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(width: 60)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(AppColors.primary.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .focused($textFieldFocused)
                        .onSubmit { commitEdit() }
                        .onChange(of: textFieldFocused) { _, focused in
                            if !focused { commitEdit() }
                        }
                } else {
                    Text("\(value)")
                        .font(.system(.body, design: .rounded, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(width: 60)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(AppColors.primary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture {
                            editText = "\(value)"
                            isEditing = true
                            textFieldFocused = true
                        }
                }

                Text(unit)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: 28, alignment: .leading)

                Button {
                    if value + step <= range.upperBound {
                        value += step
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(value >= range.upperBound ? AppColors.textSecondary.opacity(0.3) : AppColors.primary)
                }
                .frame(minWidth: 44, minHeight: 44)
                .disabled(value >= range.upperBound)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue("\(value) \(unit)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if value + step <= range.upperBound { value += step }
            case .decrement:
                if value - step >= range.lowerBound { value -= step }
            @unknown default: break
            }
        }
    }

    private func commitEdit() {
        if let newValue = Int(editText) {
            value = min(max(newValue, range.lowerBound), range.upperBound)
        }
        isEditing = false
        textFieldFocused = false
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
        .frame(minHeight: 44)
        .accessibilityLabel(level.rawValue)
        .accessibilityHint(level.description)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
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
        .frame(minHeight: 44)
        .accessibilityLabel(type.rawValue)
        .accessibilityHint(isSelected ? "Selected. Tap to deselect." : "Tap to select.")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}
