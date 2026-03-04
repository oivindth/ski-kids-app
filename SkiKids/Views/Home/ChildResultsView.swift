import SwiftUI
import SwiftData

struct ChildResultsView: View {
    let child: Child

    @State private var viewModel = CalculatorViewModel()

    var body: some View {
        Group {
            if let recommendation = viewModel.recommendation {
                ResultsView(
                    recommendation: recommendation,
                    existingChild: child,
                    onSave: {}
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            CalculatorFormView(existingChild: child)
                        } label: {
                            Text("Edit")
                                .fontWeight(.semibold)
                                .foregroundStyle(AppColors.primary)
                        }
                    }
                }
            } else if viewModel.hasAttemptedCalculation {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(AppColors.warning)
                    Text("Unable to calculate recommendations.")
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    NavigationLink {
                        CalculatorFormView(existingChild: child)
                    } label: {
                        Text("Edit Profile")
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.primary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            recalculate()
        }
        .onChange(of: child.heightCm) { recalculate() }
        .onChange(of: child.weightKg) { recalculate() }
        .onChange(of: child.age) { recalculate() }
        .onChange(of: child.abilityLevel) { recalculate() }
        .onChange(of: child.skiTypes) { recalculate() }
        .onChange(of: child.bslMm) { recalculate() }
        .onChange(of: child.name) { recalculate() }
    }

    private func recalculate() {
        viewModel.populate(from: child)
        viewModel.calculate()
    }
}
