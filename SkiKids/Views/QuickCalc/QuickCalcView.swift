import SwiftUI

struct QuickCalcView: View {
    @State private var viewModel = CalculatorViewModel()
    @State private var showingResults = false
    @State private var validationAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        infoHeader
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
            .navigationTitle("Quick Calc")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        viewModel.reset()
                    }
                    .foregroundStyle(AppColors.textSecondary)
                }
            }
            .navigationDestination(isPresented: $showingResults) {
                if let rec = viewModel.recommendation {
                    ResultsView(
                        recommendation: rec,
                        existingChild: nil,
                        onSave: {}
                    )
                }
            }
            .alert("Please fix the following", isPresented: $validationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.validationErrors.joined(separator: "\n"))
            }
        }
    }

    private var infoHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "bolt.fill")
                .font(.title2)
                .foregroundStyle(AppColors.accent)

            VStack(alignment: .leading, spacing: 2) {
                Text("Instant Recommendation")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)
                Text("Results are not saved. Use 'My Kids' to save profiles.")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()
        }
        .padding(14)
        .background(AppColors.primary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
                showingResults = true
            } else {
                validationAlert = true
            }
        } label: {
            HStack {
                Image(systemName: "bolt.fill")
                Text("Get Recommendations")
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
}
