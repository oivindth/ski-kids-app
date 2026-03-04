import SwiftUI

struct QuickCalcView: View {
    @State private var viewModel = CalculatorViewModel()
    @State private var showingResults = false

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
            .sensoryFeedback(.success, trigger: showingResults)
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
                showingResults = true
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
