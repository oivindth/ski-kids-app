import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Child.createdAt, order: .reverse) private var children: [Child]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ChildViewModel()
    @State private var showingAddChild = false
    @State private var selectedChild: Child?

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                if children.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(children) { child in
                                NavigationLink(destination: childDestination(for: child)) {
                                    ChildCardView(child: child) {
                                        viewModel.deleteChild(child, from: modelContext)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("My Kids")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddChild = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(AppColors.accent)
                    }
                }
            }
            .sheet(isPresented: $showingAddChild) {
                CalculatorFormView(existingChild: nil)
            }
        }
    }

    @ViewBuilder
    private func childDestination(for child: Child) -> some View {
        CalculatorFormView(existingChild: child)
    }

    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.skiing.downhill")
                .font(.system(size: 72))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 8) {
                Text("No Profiles Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textPrimary)

                Text("Add your first child to get personalized ski equipment recommendations.")
                    .font(.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Button {
                showingAddChild = true
            } label: {
                Label("Add Child Profile", systemImage: "plus")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [AppColors.accent, AppColors.accent.opacity(0.85)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 40)
        }
    }
}
